// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiRoadmap
/// @notice Public living roadmap (repo #95)
contract KagamiRoadmap is Ownable {
    enum Phase { PHASE0, PHASE1, PHASE2, PHASE3, PHASE4, PHASE5, LONGTERM }
    
    struct Milestone {
        uint256 id;
        Phase phase;
        string title;
        string description;
        uint256 targetDate;
        bool completed;
        uint256 completedAt;
    }
    
    uint256 public milestoneCount;
    mapping(uint256 => Milestone) public milestones;
    mapping(uint256 => uint256[]) public phaseMilestones;
    
    event MilestoneAdded(uint256 indexed milestoneId, Phase phase, string title);
    event MilestoneCompleted(uint256 indexed milestoneId, uint256 timestamp);
    event PhaseUpdated(Phase indexed phase, bool completed);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Add milestone to roadmap
    function addMilestone(
        Phase _phase,
        string calldata _title,
        string calldata _description,
        uint256 _targetDate
    ) external onlyOwner returns (uint256) {
        milestoneCount++;
        
        milestones[milestoneCount] = Milestone({
            id: milestoneCount,
            phase: _phase,
            title: _title,
            description: _description,
            targetDate: _targetDate,
            completed: false,
            completedAt: 0
        });
        
        phaseMilestones[uint256(_phase)].push(milestoneCount);
        
        emit MilestoneAdded(milestoneCount, _phase, _title);
        return milestoneCount;
    }
    
    /// @notice Complete milestone
    function completeMilestone(uint256 _milestoneId) external onlyOwner {
        Milestone storage m = milestones[_milestoneId];
        require(!m.completed, "Already completed");
        
        m.completed = true;
        m.completedAt = block.timestamp;
        
        emit MilestoneCompleted(_milestoneId, block.timestamp);
        
        // Check if phase is complete
        uint256[] storage phaseMs = phaseMilestones[uint256(m.phase)];
        bool phaseComplete = true;
        for (uint256 i = 0; i < phaseMs.length; i++) {
            if (!milestones[phaseMs[i]].completed) {
                phaseComplete = false;
                break;
            }
        }
        
        if (phaseComplete) {
            emit PhaseUpdated(m.phase, true);
        }
    }
    
    /// @notice Get milestone details
    function getMilestone(uint256 _milestoneId) external view returns (Milestone memory) {
        return milestones[_milestoneId];
    }
    
    /// @notice Get milestones by phase
    function getMilestonesByPhase(Phase _phase) external view returns (uint256[] memory) {
        return phaseMilestones[uint256(_phase)];
    }
    
    /// @notice Get all milestones
    function getAllMilestones() external view returns (uint256[] memory) {
        uint256[] memory all = new uint256[](milestoneCount);
        for (uint256 i = 1; i <= milestoneCount; i++) {
            all[i-1] = i;
        }
        return all;
    }
    
    /// @notice Check if phase is complete
    function isPhaseComplete(Phase _phase) public view returns (bool) {
        uint256[] storage phaseMs = phaseMilestones[uint256(_phase)];
        for (uint256 i = 0; i < phaseMs.length; i++) {
            if (!milestones[phaseMs[i]].completed) {
                return false;
            }
        }
        return phaseMs.length > 0;
    }
}
