// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../PointManagement.sol";

contract PointManagementFactory is Ownable {
    UpgradeableBeacon public beacon;
    address[] public pointManagementContracts;

    event PointManagementContractCreated(
        address indexed creator,
        address indexed pointManagementContract
    );
    event ImplementationUpgraded(address indexed newImplementation);

    constructor(address initialImplementation) Ownable(msg.sender) {
        // Create a beacon pointing to the initial implementation
        beacon = new UpgradeableBeacon(initialImplementation, msg.sender);
    }

    function createPointManagementContract(
        address masterAddress
    ) external returns (address) {
        // Deploy a new proxy pointing to the beacon
        BeaconProxy proxy = new BeaconProxy(
            address(beacon),
            abi.encodeWithSelector(
                PointManagement(address(0)).initialize.selector,
                masterAddress
            )
        );

        // Store the new contract address
        pointManagementContracts.push(address(proxy));

        emit PointManagementContractCreated(msg.sender, address(proxy));

        return address(proxy);
    }

    function upgradeImplementation(
        address newImplementation
    ) external onlyOwner {
        // Update the implementation contract in the beacon
        beacon.upgradeTo(newImplementation);
        emit ImplementationUpgraded(newImplementation);
    }

    function getPointManagementContracts()
        external
        view
        returns (address[] memory)
    {
        return pointManagementContracts;
    }
}
