// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "./interfaces/IPaymentProcessor.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./utils/IAccessControlErrors.sol";
import "./interfaces/IPaymentProcessorErrors.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract WonderbitsPaymentProcessor is IPaymentProcessor, AccessControl, ReentrancyGuard, IAccessControlErrors, IPaymentProcessorErrors {
    // maps from a token's contract address to a boolean indicating if they're accepted as a payment method.
    mapping (address => bool) internal _acceptedPaymentTokens;
    // maps from a user's wallet address to a payment id to the payment details of that payment.
    mapping (address => mapping (uint256 => PaymentDetails)) internal _payments;

    /**
     * @dev Throws if the caller is not an admin.
     */
    modifier onlyAdmin() {
        if (!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
            revert NotAdmin();
        }
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
    function pay(bytes32 package, uint256 price, address token) external nonReentrant {

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
}