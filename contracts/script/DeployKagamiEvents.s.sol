// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiEvents.sol";

/// @title DeployKagamiEvents
/// @notice Deployment script for KagamiEvents (repo #92 final)
contract DeployKagamiEvents is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiEvents events = new KagamiEvents();
        console.log("KagamiEvents deployed to:", address(events));
        
        vm.stopBroadcast();
    }
}
