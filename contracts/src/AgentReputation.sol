// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AgentReputation
/// @notice Onchain performance scoring (repo #21)
contract AgentReputation is Ownable {
    struct Reputation {
        uint256 agentId;
        uint256 totalScore;
        uint256 totalActions;
        uint256 successfulActions;
        uint256 averageScore; // 0-100 scale
        bool active;
    }
    
    mapping(uint256 => Reputation) public reputations;
    mapping(uint256 => uint256[]) public agentScores; // historical scores
    
    uint256 public constant MAX_SCORE = 100;
    
    event ScoreUpdated(uint256 indexed agentId, uint256 newScore, uint256 timestamp);
    event ActionRecorded(uint256 indexed agentId, bool success, uint256 timestamp);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Record an action and update reputation
    function recordAction(uint256 _agentId, bool _success, uint256 _actionScore) external onlyOwner {
        Reputation storage rep = reputations[_agentId];
        
        if (!rep.active) {
            rep.agentId = _agentId;
            rep.active = true;
        }
        
        rep.totalActions++;
        agentScores[_agentId].push(_actionScore);
        
        if (_success) {
            rep.successfulActions++;
        }
        
        // Update average score
        uint256 totalScore = 0;
        for (uint256 i = 0; i < agentScores[_agentId].length; i++) {
            totalScore += agentScores[_agentId][i];
        }
        rep.averageScore = totalScore / agentScores[_agentId].length;
        rep.totalScore = totalScore;
        
        emit ScoreUpdated(_agentId, rep.averageScore, block.timestamp);
        emit ActionRecorded(_agentId, _success, block.timestamp);
    }
    
    /// @notice Get agent reputation
    function getReputation(uint256 _agentId) external view returns (
        uint256 totalScore,
        uint256 totalActions,
        uint256 successfulActions,
        uint256 averageScore,
        bool active
    ) {
        Reputation storage rep = reputations[_agentId];
        return (rep.totalScore, rep.totalActions, rep.successfulActions, rep.averageScore, rep.active);
    }
    
    /// @notice Check if agent is reputable (avg score > 70)
    function isReputable(uint256 _agentId) external view returns (bool) {
        return reputations[_agentId].averageScore > 70;
    }
}
