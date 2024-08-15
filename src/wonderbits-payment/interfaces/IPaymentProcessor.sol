// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/**
 * @dev Interface for payment processing functionality and logic for Wonderbits.
 */
interface IPaymentProcessor {
    /** 
     * @dev Represents details of a payment.
     */
    struct PaymentDetails {
        // a unique payment id used to identify the payment
        uint256 paymentId;
        // [0] - the purchaser's wallet address
        // [1] - the payment token's contract address (e.g. USDT's contract address)
        address[2] addrs;
        // the purchased package in bytes32 format
        bytes32 package;
        // the package's price/cost
        uint256 price;
    }
}