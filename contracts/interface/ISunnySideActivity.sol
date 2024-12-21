// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

interface ISunnySideActivity {
    /* ==========================================================
     * User Management
     * ==========================================================
     */

    /// @notice Adds a user to the whitelist.
    /// @param user The address of the user to be whitelisted.
    function addToWhitelist(address user) external;

    /// @notice Checks if a user is whitelisted.
    /// @param user The address of the user to check.
    /// @return isWhitelisted Returns true if the user is whitelisted.
    function isWhitelisted(
        address user
    ) external view returns (bool isWhitelisted);

    /* ==========================================================
     * Referral System
     * ==========================================================
     */

    /// @notice Add a referral relationship.
    /// @param user The address of the referred.
    /// @param referrer The signature of the referrer.
    function joinWithReferral(address user, address referrer) external;

    /// @notice Checks if a user has already been referred.
    /// @param user The address of the user to check.
    /// @return isReferred Returns true if the user has already been referred.
    function isReferred(address user) external view returns (bool isReferred);

    /* ==========================================================
     * Points Management
     * ==========================================================
     */

    /// @notice Perform a daily login to earn points.
    function dailyLogin(address user) external;

    /// @notice Perform a fishing activity.
    /// @param fishName The type of fish caught (e.g., "Salmon", "Trout").
    function catchFish(address user, string calldata fishName) external;

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

    /* ==========================================================
     * Events
     * ==========================================================
     */

    /// @dev Emitted when a whitelist user is added.
    /// @param user The address of the user who added to whitelist.
    /// @param whitelisted The whitelist status of the user.
    event WhitelistAdded(address indexed user, bool whitelisted);

    /// @dev Emitted when points are added to a user.
    /// @param user The address of the user who received points.
    /// @param activity The name of the activity.
    /// @param points The number of points added.
    event PointsAdded(
        address indexed user,
        string indexed activity,
        uint256 points
    );

    /// @dev Emitted when a referral is successfully completed.
    /// @param referrer The address of the referrer.
    /// @param referred The address of the referred user.
    event ReferralCompleted(address indexed referrer, address indexed referred);

    /// @dev Emitted when a user successfully performs a daily login.
    /// @param user The address of the user.
    /// @param pointsEarned The number of points earned from the daily login.
    event DailyLogin(address indexed user, uint256 pointsEarned);

    /// @dev Emitted when a user successfully catches a fish.
    /// @param user The address of the user.
    /// @param fishType The type of fish caught.
    /// @param pointsEarned The number of points earned for the fish.
    event FishCatched(
        address indexed user,
        string indexed fishType,
        uint256 pointsEarned
    );

    /// @dev Emitted when a user opens a random chest.
    /// @param user The address of the user.
    /// @param pointsEarned The number of points earned from the chest.
    event ChestOpened(address indexed user, uint256 pointsEarned);

    /// @dev Emitted when a new signer assigned to the contract.
    /// @param newSigner The address of the new signer.
    event SignerUpdated(address indexed newSigner);
}
