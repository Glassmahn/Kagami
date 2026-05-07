// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiVirtualsBridge
/// @notice One-click migration of existing agents (repo #47)
interface IKagamiVirtualsBridge {
    struct VirtualAgent {
        uint256 id;
        address originalOwner;
        string metadataURI;
        uint256 migratedToKagamiAgentId;
        bool migrated;
        uint256 migratedAt;
    }
    
    event AgentDetected(uint256 indexed virtualAgentId, address owner, string metadataURI);
    event MigrationStarted(uint256 indexed virtualAgentId, uint256 kagamiAgentId);
    event MigrationCompleted(uint256 indexed virtualAgentId, uint256 kagamiAgentId);
    
    /// @notice Register a virtual agent for migration
    function registerVirtualAgent(
        address _owner,
        string calldata _metadataURI
    ) external returns (uint256);
    
    /// @notice Start migration to KAGAMI agent
    function startMigration(uint256 _virtualAgentId) external returns (uint256 kagamiAgentId);
    
    /// @notice Complete migration (admin after validation)
    function completeMigration(uint256 _virtualAgentId) external;
    
    /// @notice Get virtual agent details
    function getVirtualAgent(uint256 _virtualAgentId) external view returns (VirtualAgent memory);
    
    /// @notice Check if agent is migrated
    function isMigrated(uint256 _virtualAgentId) external view returns (bool);
    
    /// @notice Get all virtual agents by owner
    function getVirtualAgentsByOwner(address _owner) 
        external view returns (uint256[] memory);
}
