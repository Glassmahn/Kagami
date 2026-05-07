// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiGrants.sol";

/// @title DeployKagamiGrants
/// @notice Deployment script for KagamiGrants (repo #93 final)
contract DeployKagamiGrants is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiGrants grants = new KagamiGrants();
        console.log("KagamiGrants deployed to:", address(grants));
        
        vm.stopBroadcast();
    }
}
