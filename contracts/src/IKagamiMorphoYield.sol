// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiMorphoYield
/// @notice Collateral shards earn yield automatically (repo #51)
interface IKagamiMorphoYield {
    struct YieldPosition {
        uint256 shardId;
        uint256 collateralAmount;
        uint256 yieldEarned;
        uint256 lastUpdateTime;
        bool active;
    }
    
    event YieldPositionCreated(uint256 indexed shardId, uint256 collateralAmount);
    event YieldClaimed(uint256 indexed shardId, uint256 amount);
    event CollateralAdded(uint256 indexed shardId, uint256 addedAmount);
    
    /// @notice Create yield position for shard
    function createYieldPosition(uint256 _shardId, uint256 _collateralAmount) 
        external returns (uint256 positionId);
    
    /// @notice Add collateral to existing position
    function addCollateral(uint256 _shardId, uint256 _amount) external;
    
    /// @notice Claim earned yield
    function claimYield(uint256 _shardId) external returns (uint256 claimed);
    
    /// @notice Get yield position
    function getYieldPosition(uint256 _shardId) 
        external view returns (YieldPosition memory);
    
    /// @notice Get total yield earned by shard
    function getTotalYield(uint256 _shardId) external view returns (uint256);
    
    /// @notice Check if position is active
    function isPositionActive(uint256 _shardId) external view returns (bool);
}
