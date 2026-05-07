// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiCompliance.sol";

/// @title DeployKagamiCompliance
/// @notice Deployment script for KagamiCompliance (repo #83 final)
contract DeployKagamiCompliance is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiCompliance compliance = new KagamiCompliance();
        console.log("KagamiCompliance deployed to:", address(compliance));
        
        vm.stopBroadcast();
    }
}
