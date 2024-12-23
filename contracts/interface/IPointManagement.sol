// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

interface IPointManagement {
    /* ==========================================================
     * Points Management
     * ==========================================================
     */

    /// @notice Get the total points for a user.
    /// @param user The address of the user.
    /// @return totalPoints The total number of points the user has earned.
    function getUserPoints(
        address user
    ) external view returns (uint256 totalPoints);

    /// @notice Get the daily quest points for a user.
    /// @param user The address of the user.
    /// @return dailyQuestPoints The number of daily quest points the user has earned.
    function getDailyQuestPoints(
        address user
    ) external view returns (uint256 dailyQuestPoints);

    /// @notice Get the activity points for a user.
    /// @param user The address of the user.
    /// @return activityPoints The number of activity points the user has earned.
    function getActivityPoints(
        address user
    ) external view returns (uint256 activityPoints);

    /// @dev Emitted when points are added to a user.
    /// @param user The address of the user who received points.
    /// @param activity The name of the activity.
    /// @param points The number of points added.
    event PointsAdded(
        address indexed user,
        string indexed activity,
        uint256 points
    );
}
