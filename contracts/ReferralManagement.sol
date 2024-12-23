// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./interface/IReferralManagement.sol";
import "./interface/ISunnysideMaster.sol";
import "./interface/IUserManagement.sol";
import "./core/SunnysideManagementBase.sol";

contract ReferralManagement is
    Initializable,
    IReferralManagement,
    SunnysideManagementBase
{
    uint256 private constant REFERRER_REWARD_POINTS = 100;
    uint256 private constant REFERRED_REWARD_POINTS = 50;

    struct Referral {
        bool referred; // Has the user been referred
        address referrer; // Address of the referrer
        uint256 referralCounts;
    }

    mapping(address => Referral) public referrals;

    function initialize(address _sunnyMaster) public initializer {
        __SunnysideManagementBase_init(_sunnyMaster);
    }

    function joinWithReferral(
        address user,
        address referrer
    ) external onlyMasterOwner(msg.sender) whenMasterNotPaused {
        IUserManagement userManagement = IUserManagement(
            ISunnysideMaster(master).getManagementAddress(
                keccak256("UserManagement")
            )
        );

        require(user != address(0), "Invalid Address");
        require(
            !userManagement.isWhitelisted(user),
            "User Already Whitelisted"
        );
        require(
            !userManagement.isWhitelisted(referrer),
            "Referrer not whitelisted"
        );

        if (user == referrer) revert("Cannot refer self");
        if (referrals[user].referred) revert("Already referred");

        userManagement.addToWhitelist(user);

        // Apply referral rewards
        referrals[user].referred = true;
        referrals[user].referrer = referrer;
        referrals[referrer].referralCounts++;

        // referrals[referrer].totalPoints += REFERRER_REWARD_POINTS;
        // referrals[user].totalPoints += REFERRED_REWARD_POINTS;

        emit ReferralCompleted(referrer, user);
    }

    function isReferred(address user) external view returns (bool) {
        return referrals[user].referred;
    }

    function getReferralCounts(
        address user
    ) external view returns (uint256 count) {
        return referrals[user].referralCounts;
    }
}
