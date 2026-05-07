// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/KagamiCore.sol";
import "../src/KagamiToken.sol";
import "../src/SeedFactory.sol";
import "../src/ReflectionEngine.sol";
import "../src/KagamiTreasury.sol";

/// @title DeployKagamiCore
/// @notice Deployment script for KagamiCore (repo #1)
contract DeployKagamiCore is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy in order
        ReflectionEngine engine = new ReflectionEngine();
        console.log("ReflectionEngine deployed to:", address(engine));
        
        KagamiToken token = new KagamiToken();
        console.log("KagamiToken deployed to:", address(token));
        
        SeedFactory factory = new SeedFactory(address(engine));
        console.log("SeedFactory deployed to:", address(factory));
        
        KagamiTreasury treasury = new KagamiTreasury();
        console.log("KagamiTreasury deployed to:", address(treasury));
        
        KagamiCore core = new KagamiCore(
            address(engine),
            address(token),
            address(factory),
            address(treasury)
        );
        console.log("KagamiCore deployed to:", address(core));
        
        vm.stopBroadcast();
    }
}
