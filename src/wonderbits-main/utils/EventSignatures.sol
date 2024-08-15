// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

// Abstract contract containing event signatures used in Wonderbits.
abstract contract EventSignatures {
    /**
     * @dev Event signature for emitting a MixpanelEventCounterIncremented event upon incrementing an action's counter.
     *
     * This event signature is obtained by: `keccak256("MixpanelEventCounterIncremented(address, bytes32)")`.
     */
    bytes32 internal constant _MIXPANEL_EVENT_COUNTER_INCREMENTED_EVENT_SIGNATURE = 0x89a19956bae505a698c5ddf53c1616b501ac75fcff661b77436ac917a15e3f92;

    /**
     * @dev Event signature for emitting an MixpanelEventCounterUpdated event upon updating an action's counter.
     *
     * This event signature is obtained by: `keccak256("MixpanelEventCounterUpdated(address, bytes32, uint256)")`.
     */
    bytes32 internal constant _MIXPANEL_EVENT_COUNTER_UPDATED_EVENT_SIGNATURE = 0x716677208892641c4024209a120da890dd40ee222d2dc6c4f17af44ab4dbaa80;

    /**
     * @dev Event signature for emitting a PointsUpdated event upon updating the player's points.
     *
     * This event signature is obtained by: `keccak256("PointsUpdated(address, uint256)")`.
     */
    bytes32 internal constant _POINTS_UPDATED_EVENT_SIGNATURE = 0x42d2ad11ff9659a0531bcc412ef69ac84d0bd266a422b949472de8092c24fa44;
}