// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "./interfaces/IPaymentProcessor.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./utils/IAccessControlErrors.sol";
import "./interfaces/IPaymentProcessorErrors.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./utils/EventSignatures.sol";

/**
 * @dev Contract to process payments on-chain for Wonderbits.
 */
contract WonderbitsPaymentProcessor is IPaymentProcessor, AccessControl, ReentrancyGuard, IAccessControlErrors, IPaymentProcessorErrors, PaymentProcessorEventSignatures {
    // maps from a token's contract address to a boolean indicating if they're accepted as a payment method.
    mapping (address => bool) internal _acceptedPaymentTokens;
    // maps from a user's wallet address to a payment id to the payment details of that payment.
    mapping (address => mapping (uint256 => PaymentDetails)) internal _payments;

    // a counter to keep track of the next payment ID used in {pay}.
    uint256 internal _nextPaymentId;

    /**
     * @dev Throws if the caller is not an admin.
     */
    modifier onlyAdmin() {
        _checkAdmin();
        _;
    }

    /**
     * @dev Throws if the token the user is trying to pay with is not accepted by the payment processor.
     */
    modifier onlyAcceptedToken(address token) {
        _checkPaymentTokenAccepted(token);
        _;
    }

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /**
     * @dev (User) Executes a payment for a package.
     *
     * NOTE: {package} and {price} MUST be accurate, else it may lead to a lost purchase.
     */
    function pay(bytes32 package, uint256 price, address token) external nonReentrant onlyAcceptedToken(token) {
        IERC20 tokenContract = IERC20(token);

        // check if the user has allowed enough amount of `token`s to be spent by the payment processor
        // this is to ensure that the payment processor can transfer the amount of `token`s from the user's wallet
        _checkTokenAllowance(tokenContract, price);

        // transfer the amount of `token`s from the user's wallet to the payment processor
        // throws if the transfer fails
        if (!tokenContract.transferFrom(_msgSender(), address(this), price)) {
            revert PaymentFailed();
        }

        // emit a PaymentExecuted event
        assembly {
            // store non-indexed params in memory
            mstore(0x00, token)
            mstore(0x20, price)

            log4(
                // pointer to the start of the data (memory location)
                0x00,
                // size of non-indexed (non-topic) data in bytes - 32 for token and 32 for price
                64,
                // topic 0 - the event signature
                _PAYMENT_EXECUTED_EVENT_SIGNATURE,
                // topic 1 - the purchaser's wallet address
                caller(),
                // topic 2 - the purchased package in bytes32 format
                package,
                // topic 3 - the payment ID
                sload(_nextPaymentId.slot)
            )

            // increment {_nextPaymentId} by 1 for the next payment
            sstore(
                // storage slot of _nextPaymentId
                _nextPaymentId.slot,
                // load the current value of _nextPaymentId and add 1
                add(sload(_nextPaymentId.slot), 1)
            )
        }

        // store the payment details
        _payments[_msgSender()][_nextPaymentId] = PaymentDetails({
            // at this point, _nextPaymentId has already been incremented by 1 via the assembly block
            // thus, we need to subtract 1 to get the correct payment ID
            paymentId: _nextPaymentId - 1,
            addrs: [_msgSender(), token],
            package: package,
            price: price
        });
    }

    /**
     * @dev Adds one or multiple payment tokens that are accepted by the payment processor.
     */
    function addPaymentTokens(address[] calldata tokens) external onlyAdmin {
        for (uint256 i = 0; i < tokens.length;) {
            _acceptedPaymentTokens[tokens[i]] = true;

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @dev Removes one or multiple payment tokens that are accepted by the payment processor.
     */
    function removePaymentTokens(address[] calldata tokens) external onlyAdmin {
        for (uint256 i = 0; i < tokens.length;) {
            _acceptedPaymentTokens[tokens[i]] = false;

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @dev Checks whether the token is accepted by the payment processor.
     */
    function paymentTokenAccepted(address token) external view returns (bool) {
        return _acceptedPaymentTokens[token];
    }

    /**
     * @dev Checks whether the token the user is trying to pay with is accepted by the payment processor.
     */
    function _checkPaymentTokenAccepted(address token) internal view {
        if (!_acceptedPaymentTokens[token]) {
            revert TokenNotAccepted(token);
        }
    }

    /**
     * @dev Checks if the user has allowed enough amount of `token`s to be spent by the payment processor.
     */
    function _checkTokenAllowance(IERC20 token, uint256 amount) internal view {
        IERC20 tokenContract = IERC20(token);
        if (tokenContract.allowance(_msgSender(), address(this)) < amount) {
            revert InsufficientAllowance();
        }
    }

    /**
     * @dev Checks if the caller is an admin.
     */
    function _checkAdmin() internal view {
        if (!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
            revert NotAdmin();
        }
    }
}