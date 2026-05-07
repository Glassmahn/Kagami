// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiAnalytics
/// @notice Live protocol health dashboard (repo #78)
interface IKagamiAnalytics {
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
    
    event MetricsUpdated(uint256 timestamp);
    event DashboardUpdated(ProtocolMetrics metrics);
    
    /// @notice Get protocol-wide metrics
    function getProtocolMetrics() external view returns (ProtocolMetrics memory);
    
    /// @notice Get reflection-specific metrics
    function getReflectionMetrics(uint256 _reflectionId) 
        external view returns (ReflectionMetrics memory);
    
    /// @notice Get trending reflections by volume
    function getTrendingReflections(uint256 _limit) 
        external view returns (uint256[] memory);
    
    /// @notice Get revenue distribution over time
    function getRevenueHistory(uint256 _fromTimestamp, uint256 _toTimestamp) 
        external view returns (uint256[] memory timestamps, uint256[] memory amounts);
    
    /// @notice Check protocol health score (0-100)
    function getHealthScore() external view returns (uint256 score);
    
    /// @notice Update metrics (called by keeper/bot)
    function updateMetrics() external;
}
