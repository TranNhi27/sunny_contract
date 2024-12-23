// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ActivityManagement is Ownable {
    string[] public activityNames;

    event ActivityAdded(uint256 activityId, string activityName);

    constructor(address initialOwner) Ownable(initialOwner) {
        activityNames.push("None");
        activityNames.push("ReferralBonus");
        activityNames.push("DailyLogin");
        activityNames.push("Fishing");
        activityNames.push("OpenChest");
    }

    function getActivityName(
        uint256 activityId
    ) external view returns (string memory) {
        return activityNames[activityId];
    }

    function addActivityName(string memory activityName) external onlyOwner {
        activityNames.push(activityName);
        emit ActivityAdded(activityNames.length - 1, activityName);
    }

    function getActivityCount() external view returns (uint256) {
        return activityNames.length;
    }
}
