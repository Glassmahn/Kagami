// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Escrow
/// @notice Creator/agent payout splitter (repo #13)
contract Escrow is Ownable {
    struct EscrowDeal {
        address creator;
        address agent;
        uint256 totalAmount;
        uint256 creatorShare; // basis points (10000 = 100%)
        uint256 agentShare; // basis points
        bool completed;
        bool refunded;
    }
    
    uint256 public dealCount;
    mapping(uint256 => EscrowDeal) public deals;
    
    event DealCreated(
        uint256 indexed dealId,
        address indexed creator,
        address indexed agent,
        uint256 totalAmount
    );
    event PayoutCompleted(uint256 indexed dealId, uint256 creatorAmount, uint256 agentAmount);
    event Refunded(uint256 indexed dealId, address indexed recipient, uint256 amount);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Create an escrow deal between creator and agent
    function createDeal(
        address _creator,
        address _agent,
        uint256 _creatorShareBP,
        uint256 _agentShareBP
    ) external payable returns (uint256) {
        require(msg.value > 0, "No funds");
        require(_creatorShareBP + _agentShareBP == 10000, "Shares must sum to 10000");
        
        dealCount++;
        deals[dealCount] = EscrowDeal({
            creator: _creator,
            agent: _agent,
            totalAmount: msg.value,
            creatorShare: _creatorShareBP,
            agentShare: _agentShareBP,
            completed: false,
            refunded: false
        });
        
        emit DealCreated(dealCount, _creator, _agent, msg.value);
        return dealCount;
    }
    
    /// @notice Execute payout to both parties
    function completeDeal(uint256 _dealId) external onlyOwner {
        EscrowDeal storage deal = deals[_dealId];
        require(!deal.completed && !deal.refunded, "Deal already finalized");
        
        deal.completed = true;
        
        uint256 creatorAmount = (deal.totalAmount * deal.creatorShare) / 10000;
        uint256 agentAmount = (deal.totalAmount * deal.agentShare) / 10000;
        
        payable(deal.creator).transfer(creatorAmount);
        payable(deal.agent).transfer(agentAmount);
        
        emit PayoutCompleted(_dealId, creatorAmount, agentAmount);
    }
    
    /// @notice Refund entire amount to creator (in case of dispute)
    function refund(uint256 _dealId) external onlyOwner {
        EscrowDeal storage deal = deals[_dealId];
        require(!deal.completed && !deal.refunded, "Deal already finalized");
        
        deal.refunded = true;
        payable(deal.creator).transfer(deal.totalAmount);
        
        emit Refunded(_dealId, deal.creator, deal.totalAmount);
    }
}
