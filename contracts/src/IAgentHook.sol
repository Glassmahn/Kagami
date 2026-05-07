// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IAgentHook
/// @notice Standard for agents to own/manage reflections (repo #6)
interface IAgentHook {
    event AgentRegistered(address indexed agent, uint256 indexed reflectionId);
    event AgentActionPerformed(uint256 indexed reflectionId, string action, bytes data);
    
    /// @notice Register an agent to manage a reflection
    function registerAgentForReflection(uint256 _reflectionId) external;
    
    /// @notice Check if agent is registered for reflection
    function isAgentRegistered(uint256 _reflectionId, address _agent) external view returns (bool);
    
    /// @notice Agent performs an action on reflection (evolve, rebalance, etc.)
    function performAction(uint256 _reflectionId, string calldata _action, bytes calldata _data) external;
    
    /// @notice Get all agents managing a reflection
    function getReflectionAgents(uint256 _reflectionId) external view returns (address[] memory);
    
    /// @notice Get reflection managed by agent
    function getAgentReflection(address _agent) external view returns (uint256);
}
