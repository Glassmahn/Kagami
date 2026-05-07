// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiGrants
/// @notice Ecosystem fund contracts (repo #93)
contract KagamiGrants is Ownable {
    struct Grant {
        uint256 id;
        address recipient;
        string purpose;
        uint256 amount;
        uint256 vestedAt;
        bool approved;
        bool claimed;
    }
    
    uint256 public grantCount;
    mapping(uint256 => Grant) public grants;
    mapping(address => uint256[]) public recipientGrants;
    
    event GrantProposed(uint256 indexed grantId, address indexed recipient, uint256 amount);
    event GrantApproved(uint256 indexed grantId);
    event GrantClaimed(uint256 indexed grantId, address indexed recipient, uint256 amount);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Propose a grant
    function proposeGrant(
        address _recipient,
        string calldata _purpose,
        uint256 _amount
    ) external payable onlyOwner returns (uint256) {
        require(msg.value >= _amount, "Insufficient payment");
        
        grantCount++;
        grants[grantCount] = Grant({
            id: grantCount,
            recipient: _recipient,
            purpose: _purpose,
            amount: _amount,
            vestedAt: 0,
            approved: false,
            claimed: false
        });
        
        recipientGrants[_recipient].push(grantCount);
        
        emit GrantProposed(grantCount, _recipient, _amount);
        return grantCount;
    }
    
    /// @notice Approve grant (governance)
    function approveGrant(uint256 _grantId) external onlyOwner {
        Grant storage grant = grants[_grantId];
        require(!grant.approved, "Already approved");
        
        grant.approved = true;
        grant.vestedAt = block.timestamp + 30 days; // 30-day vesting
        
        emit GrantApproved(_grantId);
    }
    
    /// @notice Claim approved grant
    function claimGrant(uint256 _grantId) external {
        Grant storage grant = grants[_grantId];
        require(msg.sender == grant.recipient, "Not recipient");
        require(grant.approved, "Not approved");
        require(!grant.claimed, "Already claimed");
        require(block.timestamp >= grant.vestedAt, "Vesting period active");
        
        grant.claimed = true;
        payable(grant.recipient).transfer(grant.amount);
        
        emit GrantClaimed(_grantId, msg.sender, grant.amount);
    }
    
    /// @notice Get grant details
    function getGrant(uint256 _grantId) external view returns (Grant memory) {
        return grants[_grantId];
    }
    
    /// @notice Get grants by recipient
    function getRecipientGrants(address _recipient) external view returns (uint256[] memory) {
        return recipientGrants[_recipient];
    }
    
    /// @notice Check if grant is claimable
    function isClaimable(uint256 _grantId) external view returns (bool) {
        Grant storage grant = grants[_grantId];
        return grant.approved && !grant.claimed && block.timestamp >= grant.vestedAt;
    }
}
