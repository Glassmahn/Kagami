// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiRelayer.sol";

/// @title DeployKagamiRelayer
/// @notice Deployment script for KagamiRelayer (repo #77)
contract DeployKagamiRelayer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiRelayer relayer = new KagamiRelayer();
        console.log("KagamiRelayer deployed to:", address(relayer));
        
        vm.stopBroadcast();
    }
}
