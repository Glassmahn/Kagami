// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./ReflectionEngine.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title BatchMint
/// @notice Gas-optimized multi-shard creation (repo #9)
contract BatchMint is Ownable {
    ReflectionEngine public reflectionEngine;
    
    event BatchCreated(
        address indexed creator,
        uint256 parentId,
        uint256[] childIds,
        uint256 timestamp
    );
    
    constructor(address _reflectionEngine) Ownable(msg.sender) {
        reflectionEngine = ReflectionEngine(_reflectionEngine);
    }
    
    /// @notice Gas-optimized batch creation of child shards
    function batchCreateShards(
        uint256 _parentId,
        string[] calldata _metadataURIs
    ) external returns (uint256[] memory) {
        uint256 length = _metadataURIs.length;
        uint256[] memory childIds = new uint256[](length);
        
        for (uint256 i = 0; i < length; i++) {
            childIds[i] = reflectionEngine.createChildShard(_parentId, _metadataURIs[i]);
        }
        
        emit BatchCreated(msg.sender, _parentId, childIds, block.timestamp);
        return childIds;
    }
    
    /// @notice Batch create reflections (no parent)
    function batchCreateReflections(
        string[] calldata _metadataURIs
    ) external returns (uint256[] memory) {
        uint256 length = _metadataURIs.length;
        uint256[] memory reflectionIds = new uint256[](length);
        
        for (uint256 i = 0; i < length; i++) {
            reflectionIds[i] = reflectionEngine.createReflection(_metadataURIs[i]);
        }
        
        return reflectionIds;
    }
}
