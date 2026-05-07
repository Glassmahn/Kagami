// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IReflectionEngine.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title CrossReflection
/// @notice Linked shards that boost each other (repo #11)
contract CrossReflection is Ownable {
    IReflectionEngine public reflectionEngine;
    
    struct BoostConfig {
        uint256 boostFactor; // basis points (10000 = 100%)
        bool active;
        uint256 totalBoosted;
    }
    
    mapping(uint256 => mapping(uint256 => bool)) public isLinked;
    mapping(uint256 => uint256[]) public linkedShards;
    mapping(bytes32 => BoostConfig) public boostConfigs;
    
    event ShardsLinked(uint256 indexed shard1, uint256 indexed shard2, uint256 timestamp);
    event BoostApplied(uint256 indexed sourceShard, uint256 indexed targetShard, uint256 boostedAmount);
    
    constructor(address _reflectionEngine) Ownable(msg.sender) {
        reflectionEngine = IReflectionEngine(_reflectionEngine);
    }
    
    /// @notice Link two shards for cross-boosting
    function linkShards(uint256 _shard1, uint256 _shard2) external {
        require(_shard1 != _shard2, "Cannot link to self");
        require(!isLinked[_shard1][_shard2], "Already linked");
        
        isLinked[_shard1][_shard2] = true;
        isLinked[_shard2][_shard1] = true;
        
        linkedShards[_shard1].push(_shard2);
        linkedShards[_shard2].push(_shard1);
        
        emit ShardsLinked(_shard1, _shard2, block.timestamp);
    }
    
    /// @notice Calculate boost for a shard based on linked shards
    function calculateBoost(uint256 _shardId, uint256 _baseAmount) 
        external view returns (uint256 boostedAmount) {
        uint256[] memory links = linkedShards[_shardId];
        uint256 totalBoost = 0;
        
        for (uint256 i = 0; i < links.length; i++) {
            (, , , , uint256 revenue) = reflectionEngine.getReflection(links[i]);
            totalBoost += revenue;
        }
        
        boostedAmount = _baseAmount + (totalBoost * 100) / 10000; // 1% boost per linked shard revenue
        return boostedAmount;
    }
}
