// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IReflectionEngine
/// @notice Interface for the KAGAMI reflection engine
interface IReflectionEngine {
    event ReflectionCreated(
        address indexed creator,
        uint256 indexed reflectionId,
        string metadataURI,
        uint256 timestamp
    );
    
    event ChildShardCreated(
        uint256 indexed parentId,
        uint256 indexed childId,
        address indexed creator
    );
    
    event RevenueDistributed(
        uint256 indexed reflectionId,
        address indexed recipient,
        uint256 amount
    );
    
    function createReflection(string calldata _metadataURI) external returns (uint256);
    
    function createChildShard(uint256 _parentId, string calldata _metadataURI) external returns (uint256);
    
    function distributeRevenue(uint256 _reflectionId) external payable;
    
    function getReflection(uint256 _reflectionId) external view returns (
        address creator,
        string memory metadataURI,
        uint256 createdAt,
        uint256 childCount,
        uint256 totalRevenue
    );
}
