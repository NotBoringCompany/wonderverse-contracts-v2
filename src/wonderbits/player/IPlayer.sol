// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/**
 * @dev Interface for player-related functionality and logic.
 */
interface IPlayer {
    function getPlayer(address player, bytes32[] calldata mixpanelEvents) external view returns (uint256 _points, uint256[] memory mixpanelEventCounters);
}