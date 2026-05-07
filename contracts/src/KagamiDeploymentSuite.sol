// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./KagamiCore.sol";
import "./KagamiToken.sol";
import "./SeedFactory.sol";
import "./ReflectionEngine.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiDeploymentSuite
/// @notice Foundry + verification scripts (repo #68)
contract KagamiDeploymentSuite is Ownable {
    struct Deployment {
        string name;
        address contractAddress;
        uint256 deployedAt;
        uint256 chainId;
        bool verified;
    }
    
    Deployment[] public deployments;
    mapping(string => address) public contractAddresses;
    
    event ContractDeployed(string name, address indexed contractAddress, uint256 chainId);
    event ContractVerified(string name, address indexed contractAddress);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Deploy full KAGAMI suite
    function deployFullSuite() external onlyOwner returns (
        address core,
        address token,
        address factory,
        address engine
    ) {
        // Deploy in order
        engine = address(new ReflectionEngine());
        deployments.push(Deployment({
            name: "ReflectionEngine",
            contractAddress: engine,
            deployedAt: block.timestamp,
            chainId: block.chainid,
            verified: false
        }));
        contractAddresses["ReflectionEngine"] = engine;
        emit ContractDeployed("ReflectionEngine", engine, block.chainid);
        
        token = address(new KagamiToken());
        deployments.push(Deployment({
            name: "KagamiToken",
            contractAddress: token,
            deployedAt: block.timestamp,
            chainId: block.chainid,
            verified: false
        }));
        contractAddresses["KagamiToken"] = token;
        emit ContractDeployed("KagamiToken", token, block.chainid);
        
        factory = address(new SeedFactory(engine));
        deployments.push(Deployment({
            name: "SeedFactory",
            contractAddress: factory,
            deployedAt: block.timestamp,
            chainId: block.chainid,
            verified: false
        }));
        contractAddresses["SeedFactory"] = factory;
        emit ContractDeployed("SeedFactory", factory, block.chainid);
        
        core = address(new KagamiCore(engine, token, factory, address(0)));
        deployments.push(Deployment({
            name: "KagamiCore",
            contractAddress: core,
            deployedAt: block.timestamp,
            chainId: block.chainid,
            verified: false
        }));
        contractAddresses["KagamiCore"] = core;
        emit ContractDeployed("KagamiCore", core, block.chainid);
        
        return (core, token, factory, engine);
    }
    
    /// @notice Verify contract on Basescan (off-chain, using Forge)
    function verifyContract(string calldata _name, string calldata _verificationArgs) 
        external onlyOwner {
        // This would call forge verify-contract with args
        // In practice, this emits an event for off-chain processing
        emit ContractVerified(_name, contractAddresses[_name]);
        
        // Update deployment record
        for (uint256 i = 0; i < deployments.length; i++) {
            if (keccak256(bytes(deployments[i].name)) == keccak256(bytes(_name))) {
                deployments[i].verified = true;
                break;
            }
        }
    }
    
    /// @notice Get all deployments
    function getAllDeployments() external view returns (Deployment[] memory) {
        return deployments;
    }
    
    /// @notice Get deployment by name
    function getDeployment(string calldata _name) external view returns (Deployment memory) {
        address addr = contractAddresses[_name];
        require(addr != address(0), "Not found");
        
        for (uint256 i = 0; i < deployments.length; i++) {
            if (deployments[i].contractAddress == addr) {
                return deployments[i];
            }
        }
        
        revert("Deployment not found");
    }
}
