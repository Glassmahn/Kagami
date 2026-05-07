// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IReflectionEngine.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Liquidation
/// @notice Underperforming shard auto-burn/liquidate (repo #12)
contract Liquidation is Ownable {
    IReflectionEngine public reflectionEngine;
    
    struct LiquidationConfig {
        uint256 minRevenueThreshold; // minimum revenue in wei
        uint256 timeThreshold; // time in seconds
        bool active;
    }
    
    mapping(uint256 => LiquidationConfig) public liquidationConfigs;
    mapping(uint256 => uint256) public lastRevenueUpdate;
    mapping(uint256 => bool) public isLiquidated;
    
    event ShardLiquidated(uint256 indexed reflectionId, uint256 timestamp);
    event LiquidationConfigSet(uint256 indexed reflectionId, uint256 minRevenue, uint256 timeThreshold);
    
    constructor(address _reflectionEngine) Ownable(msg.sender) {
        reflectionEngine = IReflectionEngine(_reflectionEngine);
    }
    
    /// @notice Set liquidation parameters for a reflection
    function setLiquidationConfig(
        uint256 _reflectionId,
        uint256 _minRevenueThreshold,
        uint256 _timeThreshold
    ) external onlyOwner {
        liquidationConfigs[_reflectionId] = LiquidationConfig({
            minRevenueThreshold: _minRevenueThreshold,
            timeThreshold: _timeThreshold,
            active: true
        });
        lastRevenueUpdate[_reflectionId] = block.timestamp;
        
        emit LiquidationConfigSet(_reflectionId, _minRevenueThreshold, _timeThreshold);
    }
    
    /// @notice Check and liquidate if conditions met
    function checkAndLiquidate(uint256 _reflectionId) external {
        LiquidationConfig storage config = liquidationConfigs[_reflectionId];
        require(config.active, "Liquidation not active");
        
        (, , , , uint256 totalRevenue) = reflectionEngine.getReflection(_reflectionId);
        
        bool timeExpired = (block.timestamp - lastRevenueUpdate[_reflectionId]) > config.timeThreshold;
        bool underperforming = totalRevenue < config.minRevenueThreshold;
        
        if (timeExpired && underperforming && !isLiquidated[_reflectionId]) {
            isLiquidated[_reflectionId] = true;
            emit ShardLiquidated(_reflectionId, block.timestamp);
        }
    }
    
    /// @notice Update revenue tracking (called when revenue received)
    function updateRevenue(uint256 _reflectionId) external {
        lastRevenueUpdate[_reflectionId] = block.timestamp;
    }
}
