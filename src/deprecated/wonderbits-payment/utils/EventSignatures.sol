// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

// Abstract contract containing event signatures used in Wonderbits' payment processor contract.
abstract contract PaymentProcessorEventSignatures {
    /**
     * @dev Event signature for emitting a PaymentExecuted event upon executing a payment.
     *
     * This event signature is obtained by: `keccak256("PaymentExecuted(address, bytes32, uint256, address, uint256)")`.
     * `address` - the purchaser's wallet address
     * `bytes32` - the purchased package in bytes32 format
     * `uint256` - the payment ID
     * `address` - the payment token's contract address (e.g. USDT's contract address)
     * `uint256` - the package's price/cost
     */
    bytes32 internal constant _PAYMENT_EXECUTED_EVENT_SIGNATURE = 0xf09cb44768149d9b1fd349bf37c7d38f7f5d3d332732b22a6426935561e6b7ca;
}