// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./interface/IPointManagement.sol";
import "./interface/ISunnysideMaster.sol";
import "./interface/IUserManagement.sol";
import "./core/SunnysideManagementBase.sol";
import "./ActivityManagement.sol";

contract PointManagement is
    Initializable,
    IPointManagement,
    SunnysideManagementBase
{
    struct Point {
        uint256 totalPoints; // Total accumulated points
        uint256 dailyQuestPoints; // Points earned through daily quests
        uint256 activityPoints; // Points earned through activities
    }

    mapping(address => Point) public points;

    modifier onlyWhitelisted(address user) {
        address userManagement = ISunnysideMaster(master).getManagementAddress(
            keccak256("UserManagement")
        );
        require(
            IUserManagement(userManagement).isWhitelisted(user),
            "User not whitelisted"
        );
        _;
    }

    function initialize(address _sunnyMaster) public initializer {
        __SunnysideManagementBase_init(_sunnyMaster);
    }

    function addPoints(
        address user,
        uint256 activityId,
        uint256 point
    )
        external
        onlyWhitelisted(user)
        onlyMasterOwner(msg.sender)
        whenMasterNotPaused
    {
        ActivityManagement activityManagement = ActivityManagement(
            ISunnysideMaster(master).getActivityManager()
        );

        string memory activityName = activityManagement.getActivityName(
            activityId
        );

        points[user].activityPoints += point;
        points[user].totalPoints += point;

        emit PointsAdded(user, activityName, point);
    }

    function getUserPoints(address user) external view returns (uint256) {
        return points[user].totalPoints;
    }

    function getDailyQuestPoints(address user) external view returns (uint256) {
        return points[user].dailyQuestPoints;
    }

    function getActivityPoints(address user) external view returns (uint256) {
        return points[user].activityPoints;
    }
}
