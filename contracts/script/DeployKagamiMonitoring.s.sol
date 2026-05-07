// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiMonitoring.sol";

/// @title DeployKagamiMonitoring
/// @notice Deployment script for KagamiMonitoring (repo #79 final)
contract DeployKagamiMonitoring is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiMonitoring monitoring = new KagamiMonitoring();
        console.log("KagamiMonitoring deployed to:", address(monitoring));
        
        vm.stopBroadcast();
    }
}
