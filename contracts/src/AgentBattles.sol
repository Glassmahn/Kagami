// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AgentBattles
/// @notice Agent vs agent reflection competition contracts (repo #20)
contract AgentBattles is Ownable {
    struct Battle {
        uint256 id;
        uint256 agent1Id;
        uint256 agent2Id;
        uint256 reflection1Id;
        uint256 reflection2Id;
        uint256 startTime;
        uint256 endTime;
        uint256 votesForAgent1;
        uint256 votesForAgent2;
        bool completed;
        uint256 winnerId; // 0 = tie, 1 = agent1, 2 = agent2
    }
    
    uint256 public battleCount;
    mapping(uint256 => Battle) public battles;
    mapping(uint256 => bool) public hasVoted;
    
    event BattleCreated(
        uint256 indexed battleId,
        uint256 agent1Id,
        uint256 agent2Id,
        uint256 reflection1Id,
        uint256 reflection2Id
    );
    event Voted(uint256 indexed battleId, address voter, uint256 votedFor);
    event BattleCompleted(uint256 indexed battleId, uint256 winnerId);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Create a battle between two agents
    function createBattle(
        uint256 _agent1Id,
        uint256 _agent2Id,
        uint256 _reflection1Id,
        uint256 _reflection2Id,
        uint256 _duration
    ) external returns (uint256) {
        battleCount++;
        
        battles[battleCount] = Battle({
            id: battleCount,
            agent1Id: _agent1Id,
            agent2Id: _agent2Id,
            reflection1Id: _reflection1Id,
            reflection2Id: _reflection2Id,
            startTime: block.timestamp,
            endTime: block.timestamp + _duration,
            votesForAgent1: 0,
            votesForAgent2: 0,
            completed: false,
            winnerId: 0
        });
        
        emit BattleCreated(battleCount, _agent1Id, _agent2Id, _reflection1Id, _reflection2Id);
        return battleCount;
    }
    
    /// @notice Vote in a battle
    function vote(uint256 _battleId, uint256 _voteForAgent) external {
        Battle storage battle = battles[_battleId];
        require(block.timestamp >= battle.startTime && block.timestamp <= battle.endTime, 
                "Voting closed");
        require(!hasVoted[msg.sender], "Already voted");
        require(_voteForAgent == 1 || _voteForAgent == 2, "Invalid vote");
        
        hasVoted[msg.sender] = true;
        
        if (_voteForAgent == 1) {
            battle.votesForAgent1++;
        } else {
            battle.votesForAgent2++;
        }
        
        emit Voted(_battleId, msg.sender, _voteForAgent);
    }
    
    /// @notice Complete battle and determine winner
    function completeBattle(uint256 _battleId) external onlyOwner {
        Battle storage battle = battles[_battleId];
        require(block.timestamp > battle.endTime, "Battle not ended");
        require(!battle.completed, "Already completed");
        
        battle.completed = true;
        
        if (battle.votesForAgent1 > battle.votesForAgent2) {
            battle.winnerId = 1;
        } else if (battle.votesForAgent2 > battle.votesForAgent1) {
            battle.winnerId = 2;
        } else {
            battle.winnerId = 0; // tie
        }
        
        emit BattleCompleted(_battleId, battle.winnerId);
    }
}
