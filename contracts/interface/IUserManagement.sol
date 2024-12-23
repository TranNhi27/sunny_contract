// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

interface IUserManagement {
    /* ==========================================================
     * User Management
     * ==========================================================
     */

    /// @notice Adds a user to the whitelist.
    /// @param user The address of the user to be whitelisted.
    function addToWhitelist(address user) external;

    /// @notice Remove a user from the whitelist.
    /// @param user The address of the user to be removed.
    function removeWhitelist(address user) external;

    /// @notice Checks if a user is whitelisted.
    /// @param user The address of the user to check.
    /// @return isWhitelisted Returns true if the user is whitelisted.
    function isWhitelisted(
        address user
    ) external view returns (bool isWhitelisted);

    /// @dev Emitted when a whitelist user is added.
    /// @param user The address of the user who added to whitelist.
    /// @param whitelisted The whitelist status of the user.
    event WhitelistAdded(address indexed user, bool whitelisted);

    /// @dev Emitted when a user successfully performs a daily login.
    /// @param user The address of the user.
    /// @param pointsEarned The number of points earned from the daily login.
    event DailyLogin(address indexed user, uint256 pointsEarned);
}
