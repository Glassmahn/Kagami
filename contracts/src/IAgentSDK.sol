// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IAgentSDK
/// @notice TypeScript SDK for agents to create/manage shards (repo #16)
interface IAgentSDK {
    event AgentRegistered(address indexed agent, string metadataURI);
    event ShardCreatedByAgent(address indexed agent, uint256 indexed shardId, string metadata);
    event AgentAction(address indexed agent, string action, bytes data);
    
    /// @notice Register a new AI agent
    function registerAgent(string calldata _metadataURI) external returns (uint256);
    
    /// @notice Create shard on behalf of an idea
    function agentCreateShard(uint256 _agentId, string calldata _metadataURI) 
        external returns (uint256);
    
    /// @notice Execute automated action (evolve, rebalance, etc.)
    function executeAction(uint256 _agentId, string calldata _action, bytes calldata _data) 
        external;
    
    /// @notice Get agent details
    function getAgent(uint256 _agentId) external view returns (
        address owner,
        string memory metadataURI,
        uint256 shardCount,
        bool active
    );
    
    /// @notice Check if caller is registered agent
    function isRegisteredAgent(address _caller) external view returns (bool);
}
