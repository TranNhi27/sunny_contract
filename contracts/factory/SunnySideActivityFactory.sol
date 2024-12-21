// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../SunnySideActivity.sol";

contract SunnySideActivityFactory is Ownable {
    UpgradeableBeacon public beacon;
    address[] public activityContracts;

    event ActivityContractCreated(
        address indexed creator,
        address indexed activityContract
    );
    event ImplementationUpgraded(address indexed newImplementation);

    constructor(address initialImplementation) Ownable(msg.sender) {
        beacon = new UpgradeableBeacon(initialImplementation, msg.sender);
    }

    function createActivityContract(address owner) external returns (address) {
        // Deploy a new proxy pointing to the beacon
        BeaconProxy proxy = new BeaconProxy(
            address(beacon),
            abi.encodeWithSelector(
                SunnySideActivity(address(0)).initialize.selector,
                owner
            )
        );

        // Store the new contract address
        activityContracts.push(address(proxy));

        emit ActivityContractCreated(msg.sender, address(proxy));

        return address(proxy);
    }

    function upgradeImplementation(
        address newImplementation
    ) external onlyOwner {
        // Update the implementation contract in the beacon
        beacon.upgradeTo(newImplementation);
        emit ImplementationUpgraded(newImplementation);
    }

    function getActivityContracts() external view returns (address[] memory) {
        return activityContracts;
    }
}
