// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiBrandAssets.sol";

/// @title DeployKagamiBrandAssets
/// @notice Deployment script for KagamiBrandAssets (repo #84)
contract DeployKagamiBrandAssets is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiBrandAssets brandAssets = new KagamiBrandAssets();
        console.log("KagamiBrandAssets deployed to:", address(brandAssets));
        
        vm.stopBroadcast();
    }
}
