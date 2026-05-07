// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiAmbassadors.sol";

/// @title DeployKagamiAmbassadors
/// @notice Deployment script for KagamiAmbassadors (repo #94 final)
contract DeployKagamiAmbassadors is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiAmbassadors ambassadors = new KagamiAmbassadors();
        console.log("KagamiAmbassadors deployed to:", address(ambassadors));
        
        vm.stopBroadcast();
    }
}
