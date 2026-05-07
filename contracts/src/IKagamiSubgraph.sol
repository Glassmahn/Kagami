// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiSubgraph
/// @notice The Graph indexing for all shards (repo #65)
interface IKagamiSubgraph {
    struct SubgraphQuery {
        string entity;
        string field;
        string value;
        uint256 timestamp;
    }
    
    event QueryExecuted(string entity, string field, uint256 resultCount);
    event IndexingUpdated(uint256 indexed reflectionId, uint256 blockNumber);
    
    /// @notice Query reflections by creator
    function queryByCreator(address _creator) 
        external view returns (uint256[] memory reflectionIds);
    
    /// @notice Query reflections by type
    function queryByType(string calldata _type) 
        external view returns (uint256[] memory reflectionIds);
    
    /// @notice Get reflection with all relationships
    function getReflectionGraph(uint256 _reflectionId) 
        external view returns (
            uint256[] memory parents,
            uint256[] memory children,
            uint256[] memory linkedShards
        );
    
    /// @notice Get protocol statistics
    function getProtocolStats() 
        external view returns (
            uint256 totalReflections,
            uint256 totalRevenue,
            uint256 activeAgents,
            uint256 totalVolume
        );
    
    /// @notice Check if entity is indexed
    function isIndexed(uint256 _reflectionId) external view returns (bool);
}
