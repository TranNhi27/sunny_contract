// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./interface/ISunnysideMaster.sol";

contract SunnysideMaster is
    Initializable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    ISunnysideMaster
{
    address private activityManager;
    mapping(bytes32 => address) private managementAddresses;

    /* ==========================================================
     * Errors
     * ==========================================================
     */

    error UserNotWhitelisted();
    error UserAlreadyWhitelisted();
    error AlreadyReferred();
    error CannotReferSelf();
    error ReferrerNotWhitelisted();

    function initialize(
        address _owner,
        address _activityManager
    ) public initializer {
        require(_owner != address(0), "Invalid Address");
        require(_activityManager != address(0), "Invalid Address");

        __Ownable_init(_owner);
        __Pausable_init();
        __ReentrancyGuard_init();
        activityManager = _activityManager;
    }

    function owner()
        public
        view
        override(OwnableUpgradeable, ISunnysideMaster)
        returns (address)
    {
        return OwnableUpgradeable.owner();
    }

    function paused()
        public
        view
        override(PausableUpgradeable, ISunnysideMaster)
        returns (bool)
    {
        return PausableUpgradeable.paused();
    }

    /* ==========================================================
     * SET
     * ==========================================================
     */

    function setManagementAddress(
        bytes32 id,
        address managementAddress
    ) external onlyOwner {
        require(managementAddress != address(0), "Invalid address");
        managementAddresses[id] = managementAddress;
        emit ManagementAddressUpdated(id, managementAddress);
    }

    function setActivityManager(address _activityManager) external onlyOwner {
        activityManager = _activityManager;
    }

    /* ==========================================================
     * GET
     * ==========================================================
     */

    function getManagementAddress(bytes32 id) external view returns (address) {
        address managementAddress = managementAddresses[id];
        require(managementAddress != address(0), "Contract not set");
        return managementAddress;
    }

    function getActivityManager() external view returns (address) {
        return activityManager;
    }

    function pauseContract() external onlyOwner {
        _pause();
    }

    function unpauseContract() external onlyOwner {
        _unpause();
    }
}
