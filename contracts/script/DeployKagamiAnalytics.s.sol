// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiAnalytics.sol";

/// @title DeployKagamiAnalytics
/// @notice Deployment script for KagamiAnalytics (repo #78 final)
contract DeployKagamiAnalytics is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiAnalytics analytics = new KagamiAnalytics();
        console.log("KagamiAnalytics deployed to:", address(analytics));
        
        vm.stopBroadcast();
    }
}
