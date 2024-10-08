// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/**
 * @dev Interface for IPlayer-related errors.
 */
interface IPlayerErrors {
    /**
     * @dev Throws if the caller is trying to fetch a player's data that is not their own or is not an admin.
     */
    error NotSelfOrAdmin();
}