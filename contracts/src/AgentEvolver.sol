// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IAgentSDK.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AgentEvolver
/// @notice Agents that auto-improve their own reflections (repo #18)
contract AgentEvolver is Ownable {
    IAgentSDK public agentSDK;
    
    struct Evolution {
        uint256 agentId;
        uint256 reflectionId;
        string evolutionType;
        uint256 scoreBefore;
        uint256 scoreAfter;
        uint256 timestamp;
        bool applied;
    }
    
    uint256 public evolutionCount;
    mapping(uint256 => Evolution) public evolutions;
    mapping(uint256 => uint256[]) public agentEvolutions;
    
    event EvolutionProposed(
        uint256 indexed evolutionId,
        uint256 indexed agentId,
        uint256 reflectionId,
        string evolutionType
    );
    event EvolutionApplied(uint256 indexed evolutionId, uint256 newScore);
    
    constructor(address _agentSDK) Ownable(msg.sender) {
        agentSDK = IAgentSDK(_agentSDK);
    }
    
    /// @notice Propose an evolution for a reflection
    function proposeEvolution(
        uint256 _agentId,
        uint256 _reflectionId,
        string calldata _evolutionType,
        uint256 _scoreBefore
    ) external returns (uint256) {
        require(agentSDK.isRegisteredAgent(msg.sender), "Not registered agent");
        
        evolutionCount++;
        evolutions[evolutionCount] = Evolution({
            agentId: _agentId,
            reflectionId: _reflectionId,
            evolutionType: _evolutionType,
            scoreBefore: _scoreBefore,
            scoreAfter: 0,
            timestamp: block.timestamp,
            applied: false
        });
        
        agentEvolutions[_agentId].push(evolutionCount);
        
        emit EvolutionProposed(evolutionCount, _agentId, _reflectionId, _evolutionType);
        return evolutionCount;
    }
    
    /// @notice Apply evolution (admin after validation)
    function applyEvolution(uint256 _evolutionId, uint256 _scoreAfter) external onlyOwner {
        Evolution storage evolution = evolutions[_evolutionId];
        require(!evolution.applied, "Already applied");
        
        evolution.applied = true;
        evolution.scoreAfter = _scoreAfter;
        
        // Call agentSDK to execute the evolution
        agentSDK.executeAction(evolution.agentId, evolution.evolutionType, "");
        
        emit EvolutionApplied(_evolutionId, _scoreAfter);
    }
    
    /// @notice Get evolutions by agent
    function getAgentEvolutions(uint256 _agentId) external view returns (uint256[] memory) {
        return agentEvolutions[_agentId];
    }
}
