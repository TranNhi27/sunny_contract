// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./interface/IUserManagement.sol";
import "./interface/ISunnysideMaster.sol";
import "./core/SunnysideManagementBase.sol";

contract UserManagement is
    Initializable,
    IUserManagement,
    SunnysideManagementBase
{
    struct User {
        bool whitelisted;
    }

    mapping(address => User) public users;

    /* ==========================================================
     * Errors
     * ==========================================================
     */

    error UserAlreadyWhitelisted();

    function initialize(address _sunnyMaster) public initializer {
        __SunnysideManagementBase_init(_sunnyMaster);
    }

    function addToWhitelist(
        address user
    ) external onlyMasterOwner(tx.origin) whenMasterNotPaused {
        if (users[user].whitelisted) revert UserAlreadyWhitelisted();

        users[user].whitelisted = true;
        emit WhitelistAdded(user, true);
    }

    function removeWhitelist(
        address user
    ) external onlyMasterOwner(msg.sender) whenMasterNotPaused {
        users[user].whitelisted = false;
        emit WhitelistAdded(user, false);
    }

    function isWhitelisted(address user) external view returns (bool) {
        return users[user].whitelisted;
    }
}
