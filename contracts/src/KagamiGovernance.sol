// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IKagamiToken.sol";

/// @title KagamiGovernance
/// @notice Onchain voting for protocol upgrades (repo #7)
contract KagamiGovernance is Ownable {
    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 startTime;
        uint256 endTime;
        bool executed;
        mapping(address => bool) voted;
    }
    
    IKagamiToken public token;
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    
    event ProposalCreated(uint256 indexed id, address indexed proposer, string description);
    event Voted(uint256 indexed proposalId, address indexed voter, bool support, uint256 weight);
    event ProposalExecuted(uint256 indexed id);
    
    constructor(address _token) Ownable(msg.sender) {
        token = IKagamiToken(_token);
    }
    
    function propose(string calldata _description) external returns (uint256) {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.id = proposalCount;
        p.proposer = msg.sender;
        p.description = _description;
        p.startTime = block.timestamp;
        p.endTime = block.timestamp + 7 days;
        
        emit ProposalCreated(proposalCount, msg.sender, _description);
        return proposalCount;
    }
    
    function vote(uint256 _proposalId, bool _support) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp >= p.startTime && block.timestamp <= p.endTime, "Voting closed");
        require(!p.voted[msg.sender], "Already voted");
        
        uint256 weight = token.getReflectionStake(_proposalId, msg.sender);
        require(weight > 0, "No stake");
        
        if (_support) {
            p.forVotes += weight;
        } else {
            p.againstVotes += weight;
        }
        
        p.voted[msg.sender] = true;
        emit Voted(_proposalId, msg.sender, _support, weight);
    }
}
