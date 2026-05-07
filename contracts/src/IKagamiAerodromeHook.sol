// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiAerodromeHook
/// @notice Instant liquidity for every new token shard (repo #46)
interface IKagamiAerodromeHook {
    struct LiquidityPool {
        uint256 shardId;
        address token;
        address pool;
        uint256 liquidity;
        bool active;
    }
    
    event PoolCreated(uint256 indexed shardId, address indexed token, address pool);
    event LiquidityAdded(uint256 indexed shardId, uint256 amount);
    event SwapExecuted(uint256 indexed shardId, uint256 amountIn, uint256 amountOut);
    
    /// @notice Create liquidity pool for new shard token
    function createPool(uint256 _shardId, address _token) external returns (address pool);
    
    /// @notice Add liquidity to pool
    function addLiquidity(uint256 _shardId, uint256 _amount) external payable;
    
    /// @notice Swap tokens in pool
    function swap(uint256 _shardId, uint256 _amountIn, uint256 _minAmountOut) 
        external returns (uint256 amountOut);
    
    /// @notice Get pool info
    function getPool(uint256 _shardId) external view returns (LiquidityPool memory);
    
    /// @notice Check if pool exists for shard
    function hasPool(uint256 _shardId) external view returns (bool);
}
