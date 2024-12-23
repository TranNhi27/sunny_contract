// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

interface IReferralManagement {
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

    /// @notice Get total count of referral for a given user address.
    /// @param user The address of the user to check.
    /// @return count Returns the number of referral this user has made.
    function getReferralCounts(
        address user
    ) external view returns (uint256 count);

    /// @dev Emitted when a referral is successfully completed.
    /// @param referrer The address of the referrer.
    /// @param referred The address of the referred user.
    event ReferralCompleted(address indexed referrer, address indexed referred);
}
