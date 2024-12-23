// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../SunnysideMaster.sol";

contract SunnysideMasterFactory is Ownable {
    UpgradeableBeacon public beacon;
    address[] public masterContracts;

    event MasterContractCreated(
        address indexed creator,
        address indexed masterContract
    );
    event ImplementationUpgraded(address indexed newImplementation);

    constructor(address initialImplementation) Ownable(msg.sender) {
        beacon = new UpgradeableBeacon(initialImplementation, msg.sender);
    }

    function createMasterContract(
        address owner,
        address activityManager
    ) external returns (address) {
        // Deploy a new proxy pointing to the beacon
        BeaconProxy proxy = new BeaconProxy(
            address(beacon),
            abi.encodeWithSelector(
                SunnysideMaster(address(0)).initialize.selector,
                owner,
                activityManager
            )
        );

        // Store the new contract address
        masterContracts.push(address(proxy));

        emit MasterContractCreated(msg.sender, address(proxy));

        return address(proxy);
    }

    function upgradeImplementation(
        address newImplementation
    ) external onlyOwner {
        // Update the implementation contract in the beacon
        beacon.upgradeTo(newImplementation);
        emit ImplementationUpgraded(newImplementation);
    }

    function getMasterContracts() external view returns (address[] memory) {
        return masterContracts;
    }
}
