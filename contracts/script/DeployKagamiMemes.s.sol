// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiMemes.sol";

/// @title DeployKagamiMemes
/// @notice Deployment script for KagamiMemes (repo #91 final)
contract DeployKagamiMemes is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiMemes memes = new KagamiMemes();
        console.log("KagamiMemes deployed to:", address(memes));
        
        vm.stopBroadcast();
    }
}
