// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiToken
/// @notice $KAGAMI governance + universal revenue share token
contract KagamiToken is ERC20, Ownable {
    struct ReflectionStake {
        uint256 amount;
        uint256 timestamp;
    }
    
    mapping(uint256 => mapping(address => ReflectionStake)) public reflectionStakes;
    mapping(uint256 => uint256) public totalReflectionStakes;
    
    event RevenueDistributed(uint256 amount, uint256 timestamp);
    event ReflectionStaked(uint256 indexed reflectionId, address indexed staker, uint256 amount);
    event ReflectionUnstaked(uint256 indexed reflectionId, address indexed staker, uint256 amount);
    
    constructor() ERC20("KAGAMI", "KAG") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000_000 * 10**decimals());
    }
    
    function distributeRevenue() external payable {
        require(msg.value > 0, "No revenue to distribute");
        emit RevenueDistributed(msg.value, block.timestamp);
    }
    
    function stakeForReflection(uint256 _reflectionId, uint256 _amount) external {
        _transfer(msg.sender, address(this), _amount);
        reflectionStakes[_reflectionId][msg.sender].amount += _amount;
        reflectionStakes[_reflectionId][msg.sender].timestamp = block.timestamp;
        totalReflectionStakes[_reflectionId] += _amount;
        emit ReflectionStaked(_reflectionId, msg.sender, _amount);
    }
    
    function unstakeFromReflection(uint256 _reflectionId, uint256 _amount) external {
        require(reflectionStakes[_reflectionId][msg.sender].amount >= _amount, "Insufficient stake");
        reflectionStakes[_reflectionId][msg.sender].amount -= _amount;
        totalReflectionStakes[_reflectionId] -= _amount;
        _transfer(address(this), msg.sender, _amount);
        emit ReflectionUnstaked(_reflectionId, msg.sender, _amount);
    }
    
    function getReflectionStake(uint256 _reflectionId, address _staker) 
        external view returns (uint256) {
        return reflectionStakes[_reflectionId][_staker].amount;
    }
}
