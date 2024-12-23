// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

interface ISunnysideMaster {
    enum Activity {
        None,
        ReferralBonus,
        DailyLogin,
        Fishing,
        OpenChest
    }

    function setManagementAddress(
        bytes32 id,
        address managementAddress
    ) external;

    function setActivityManager(address _activityManager) external;

    function getActivityManager() external view returns (address);

    // Explicitly declare functions inherited from OwnableUpgradeable
    function owner() external view returns (address);

    // Declare other relevant functions for ISunnysideMaster
    function paused() external view returns (bool);

    function getManagementAddress(
        bytes32 id
    ) external view returns (address managementAddress);

    // Event to log updates or additions of new contracts
    event ManagementAddressUpdated(bytes32 indexed id, address contractAddress);
}
