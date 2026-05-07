// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IReflectionEngine.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title ReflectionEngine
/// @notice Logic that auto-generates infinite child shards
contract ReflectionEngine is IReflectionEngine, Ownable {
    struct Reflection {
        address creator;
        string metadataURI;
        uint256 createdAt;
        uint256 childCount;
        uint256 totalRevenue;
    }
    
    uint256 public nextReflectionId = 1;
    mapping(uint256 => Reflection) public reflections;
    mapping(uint256 => uint256[]) public childShards;
    
    function createReflection(string calldata _metadataURI) external override returns (uint256) {
        uint256 reflectionId = nextReflectionId++;
        
        reflections[reflectionId] = Reflection({
            creator: msg.sender,
            metadataURI: _metadataURI,
            createdAt: block.timestamp,
            childCount: 0,
            totalRevenue: 0
        });
        
        emit ReflectionCreated(msg.sender, reflectionId, _metadataURI, block.timestamp);
        
        return reflectionId;
    }
    
    function createChildShard(uint256 _parentId, string calldata _metadataURI) 
        external override returns (uint256) {
        require(_parentId > 0 && _parentId < nextReflectionId, "Invalid parent");
        
        uint256 childId = nextReflectionId++;
        reflections[childId] = Reflection({
            creator: msg.sender,
            metadataURI: _metadataURI,
            createdAt: block.timestamp,
            childCount: 0,
            totalRevenue: 0
        });
        
        childShards[_parentId].push(childId);
        reflections[_parentId].childCount++;
        
        emit ChildShardCreated(_parentId, childId, msg.sender);
        
        return childId;
    }
    
    function distributeRevenue(uint256 _reflectionId) external payable override {
        require(_reflectionId > 0 && _reflectionId < nextReflectionId, "Invalid reflection");
        reflections[_reflectionId].totalRevenue += msg.value;
        emit RevenueDistributed(_reflectionId, msg.sender, msg.value);
    }
    
    function getReflection(uint256 _reflectionId) 
        external view override returns (
            address creator,
            string memory metadataURI,
            uint256 createdAt,
            uint256 childCount,
            uint256 totalRevenue
        ) {
        Reflection storage r = reflections[_reflectionId];
        return (r.creator, r.metadataURI, r.createdAt, r.childCount, r.totalRevenue);
    }
}
