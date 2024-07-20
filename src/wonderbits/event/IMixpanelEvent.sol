// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/**
 * @dev Interface for Mixpanel event-related functionality and logic.
 */
interface IMixpanelEvent {
    function incrementEventCounter(
        address player, 
        bytes32 mixpanelEvent
    ) external;
    function updateEventCounter(
        address player, 
        bytes32 mixpanelEvent, 
        uint256 newCounter
    ) external;
}