// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiAnalytics
/// @notice Live protocol health dashboard (repo #78)
contract KagamiAnalytics is Ownable {
    struct ProtocolMetrics {
        uint256 totalReflections;
        uint256 totalRevenue;
        uint256 activeAgents;
        uint256 totalVolume24h;
        uint256 uniqueCreators;
    }
    
    struct ReflectionMetrics {
        uint256 reflectionId;
        uint256 revenue24h;
        uint256 volume24h;
        uint256 holders;
        uint256 creatorCount;
    }
    
    ProtocolMetrics public protocolMetrics;
    mapping(uint256 => ReflectionMetrics) public reflectionMetrics;
    mapping(uint256 => uint256) public reflectionVolume;
    uint256 public totalVolume24h;
    uint256 public lastUpdateTime;
    uint256 public healthScore;
    
    event MetricsUpdated(uint256 timestamp);
    event ReflectionUpdated(uint256 indexed reflectionId, uint256 timestamp);
    event HealthScoreUpdated(uint256 score, uint256 timestamp);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Update protocol-wide metrics (called by keeper)
    function updateProtocolMetrics(
        uint256 _totalReflections,
        uint256 _totalRevenue,
        uint256 _activeAgents,
        uint256 _totalVolume24h,
        uint256 _uniqueCreators
    ) external onlyOwner {
        protocolMetrics = ProtocolMetrics({
            totalReflections: _totalReflections,
            totalRevenue: _totalRevenue,
            activeAgents: _activeAgents,
            totalVolume24h: _totalVolume24h,
            uniqueCreators: _uniqueCreators
        });
        
        totalVolume24h = _totalVolume24h;
        lastUpdateTime = block.timestamp;
        
        emit MetricsUpdated(block.timestamp);
    }
    
    /// @notice Update reflection metrics
    function updateReflectionMetrics(
        uint256 _reflectionId,
        uint256 _revenue24h,
        uint256 _volume24h,
        uint256 _holders,
        uint256 _creatorCount
    ) external onlyOwner {
        reflectionMetrics[_reflectionId] = ReflectionMetrics({
            reflectionId: _reflectionId,
            revenue24h: _revenue24h,
            volume24h: _volume24h,
            holders: _holders,
            creatorCount: _creatorCount
        });
        
        reflectionVolume[_reflectionId] = _volume24h;
        
        emit ReflectionUpdated(_reflectionId, block.timestamp);
    }
    
    /// @notice Update health score (0-100)
    function updateHealthScore(uint256 _score) external onlyOwner {
        require(_score <= 10000, "Score must be <= 10000");
        healthScore = _score;
        emit HealthScoreUpdated(_score, block.timestamp);
    }
    
    /// @notice Get protocol-wide metrics
    function getProtocolMetrics() external view returns (ProtocolMetrics memory) {
        return protocolMetrics;
    }
    
    /// @notice Get reflection-specific metrics
    function getReflectionMetrics(uint256 _reflectionId) 
        external view returns (ReflectionMetrics memory) {
        return reflectionMetrics[_reflectionId];
    }
    
    /// @notice Get trending reflections by volume
    function getTrendingReflections(uint256 _limit) 
        external view returns (uint256[] memory) {
        // Simplified - return all reflection IDs with volume > 0
        uint256 count = 0;
        for (uint256 i = 1; i <= protocolMetrics.totalReflections; i++) {
            if (reflectionVolume[i] > 0) count++;
        }
        
        uint256[] memory trending = new uint256[](count);
        uint256 index = 0;
        for (uint256 i = 1; i <= protocolMetrics.totalReflections; i++) {
            if (reflectionVolume[i] > 0) {
                trending[index++] = i;
            }
        }
        
        // Trim to limit
        if (_limit < count) {
            uint256[] memory trimmed = new uint256[](_limit);
            for (uint256 i = 0; i < _limit; i++) {
                trimmed[i] = trending[i];
            }
            return trimmed;
        }
        
        return trending;
    }
    
    /// @notice Get revenue history (simplified - returns single value)
    function getRevenueHistory(uint256 /*_fromTimestamp*/, uint256 /*_toTimestamp*/) 
        external view returns (uint256[] memory timestamps, uint256[] memory amounts) {
        timestamps = new uint256[](1);
        amounts = new uint256[](1);
        timestamps[0] = lastUpdateTime;
        amounts[0] = protocolMetrics.totalRevenue;
    }
    
    /// @notice Check protocol health score (0-100)
    function getHealthScore() external view returns (uint256) {
        return healthScore / 100; // Convert basis points to percentage
    }
}
