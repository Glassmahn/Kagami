// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiIndexer.sol";

/// @title DeployKagamiIndexer
/// @notice Deployment script for KagamiIndexer (repo #76 final)
contract DeployKagamiIndexer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        KagamiIndexer indexer = new KagamiIndexer();
        console.log("KagamiIndexer deployed to:", address(indexer));
        
        vm.stopBroadcast();
    }
}
