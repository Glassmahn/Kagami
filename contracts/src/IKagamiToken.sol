// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title IKagamiToken
/// @notice Interface for $KAGAMI governance + revenue share token
interface IKagamiToken is IERC20 {
    event RevenueDistributed(uint256 amount, uint256 timestamp);
    event ReflectionStaked(uint256 indexed reflectionId, address indexed staker, uint256 amount);
    
    function distributeRevenue() external payable;
    
    function stakeForReflection(uint256 _reflectionId, uint256 _amount) external;
    
    function unstakeFromReflection(uint256 _reflectionId, uint256 _amount) external;
    
    function getReflectionStake(uint256 _reflectionId, address _staker) 
        external view returns (uint256);
    
    function totalReflectionStake(uint256 _reflectionId) external view returns (uint256);
}
