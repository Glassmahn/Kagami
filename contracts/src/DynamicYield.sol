// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title DynamicYield
/// @notice Auto-yield on every reflection layer (repo #10)
contract DynamicYield is Ownable {
    struct YieldConfig {
        uint256 baseAPY; // basis points (100 = 1%)
        uint256 reflectionMultiplier;
        uint256 maxAPY;
        bool active;
    }
    
    mapping(uint256 => YieldConfig) public yieldConfigs;
    mapping(uint256 => mapping(address => uint256)) public stakedAmounts;
    mapping(uint256 => mapping(address => uint256)) public lastUpdateTime;
    
    event YieldStaked(uint256 indexed reflectionId, address indexed user, uint256 amount);
    event YieldClaimed(uint256 indexed reflectionId, address indexed user, uint256 reward);
    event YieldConfigUpdated(uint256 indexed reflectionId, uint256 baseAPY);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Configure yield for a reflection
    function setYieldConfig(
        uint256 _reflectionId,
        uint256 _baseAPY,
        uint256 _multiplier,
        uint256 _maxAPY
    ) external onlyOwner {
        yieldConfigs[_reflectionId] = YieldConfig({
            baseAPY: _baseAPY,
            reflectionMultiplier: _multiplier,
            maxAPY: _maxAPY,
            active: true
        });
        
        emit YieldConfigUpdated(_reflectionId, _baseAPY);
    }
    
    /// @notice Stake for yield
    function stake(uint256 _reflectionId, uint256 _amount) external payable {
        require(yieldConfigs[_reflectionId].active, "Yield not active");
        
        stakedAmounts[_reflectionId][msg.sender] += _amount;
        lastUpdateTime[_reflectionId][msg.sender] = block.timestamp;
        
        emit YieldStaked(_reflectionId, msg.sender, _amount);
    }
    
    /// @notice Calculate pending reward
    function pendingReward(uint256 _reflectionId, address _user) 
        external view returns (uint256) {
        YieldConfig storage config = yieldConfigs[_reflectionId];
        uint256 staked = stakedAmounts[_reflectionId][_user];
        
        if (staked == 0 || !config.active) return 0;
        
        uint256 timeStaked = block.timestamp - lastUpdateTime[_reflectionId][_user];
        uint256 reward = (staked * config.baseAPY * timeStaked) / (10000 * 365 days);
        
        return reward > config.maxAPY ? config.maxAPY : reward;
    }
}
