// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiTestnetTools
/// @notice Base Sepolia faucet + demo seeds (repo #67)
interface IKagamiTestnetTools {
    struct FaucetRequest {
        address user;
        uint256 amount;
        uint256 timestamp;
        bool fulfilled;
    }
    
    struct DemoSeed {
        uint256 id;
        string idea;
        address creator;
        uint256 reflectionId;
        bool claimed;
    }
    
    event FaucetDripped(address indexed user, uint256 amount);
    event DemoSeedCreated(uint256 indexed seedId, string idea, address creator);
    event DemoReflectionClaimed(uint256 indexed seedId, uint256 reflectionId);
    
    /// @notice Request testnet ETH from faucet
    function requestFaucet() external payable returns (bool);
    
    /// @notice Create demo seed (pre-defined ideas for testing)
    function createDemoSeed(string calldata _idea, address _creator) 
        external returns (uint256 seedId);
    
    /// @notice Claim demo seed as reflection
    function claimDemoSeed(uint256 _seedId) external returns (uint256 reflectionId);
    
    /// @notice Get demo seed
    function getDemoSeed(uint256 _seedId) external view returns (DemoSeed memory);
    
    /// @notice Get all demo seeds
    function getAllDemoSeeds() external view returns (uint256[] memory);
    
    /// @notice Check if user can request faucet
    function canRequestFaucet(address _user) external view returns (bool);
}
