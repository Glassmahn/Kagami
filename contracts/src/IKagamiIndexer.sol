// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiIndexer
/// @notice Custom real-time shard data indexer (repo #76)
interface IKagamiIndexer {
    struct IndexedReflection {
        uint256 id;
        address creator;
        string metadataURI;
        uint256 blockNumber;
        uint256 timestamp;
        uint256 parentId;
        uint256[] childIds;
    }
    
    event ReflectionIndexed(uint256 indexed reflectionId, uint256 blockNumber);
    event IndexUpdated(uint256 indexed reflectionId, uint256 latestBlock);
    
    /// @notice Index a new reflection
    function indexReflection(uint256 _reflectionId) external;
    
    /// @notice Get indexed reflection data
    function getIndexedReflection(uint256 _reflectionId) 
        external view returns (IndexedReflection memory);
    
    /// @notice Get reflections by block range
    function getReflectionsByBlock(uint256 _fromBlock, uint256 _toBlock) 
        external view returns (uint256[] memory);
    
    /// @notice Get latest indexed block
    function getLatestBlock() external view returns (uint256);
    
    /// @notice Check if reflection is indexed
    function isIndexed(uint256 _reflectionId) external view returns (bool);
    
    /// @notice Get total indexed count
    function getTotalIndexed() external view returns (uint256);
}
