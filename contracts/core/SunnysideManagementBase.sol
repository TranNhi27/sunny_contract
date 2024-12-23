// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;
import "../interface/ISunnysideMaster.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract SunnysideManagementBase is Initializable {
    address public master;

    function __SunnysideManagementBase_init(
        address _master
    ) internal initializer {
        require(_master != address(0), "Master address cannot be zero");
        master = _master;
    }

    modifier onlyMasterOwner(address owner) {
        require(
            ISunnysideMaster(master).owner() == owner,
            "Unauthorized Account"
        );
        _;
    }

    modifier whenMasterNotPaused() {
        require(!ISunnysideMaster(master).paused(), "Contract Paused");
        _;
    }

    function setMasterAddress(
        address _masterAddress
    ) external onlyMasterOwner(msg.sender) {
        master = _masterAddress;
    }
}
