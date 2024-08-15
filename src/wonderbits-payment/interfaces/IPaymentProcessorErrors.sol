// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/**
 * @dev Interface for IPaymentProcessor-related errors.
 */
interface IPaymentProcessorErrors {
    /**
     * @dev Throws if the token the user is trying to pay with is not accepted by the payment processor.
     */
    error TokenNotAccepted(address token);

    /**
     * @dev Throws if the payment failed.
     */
    error PaymentFailed();

    /**
     * @dev Throws if the user has not allowed enough amount of `token`s to be spent by the payment processor.
     */
    error InsufficientAllowance();
}