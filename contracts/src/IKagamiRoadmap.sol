// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiRoadmap
/// @notice Public living roadmap (repo #95)
interface IKagamiRoadmap {
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
    
    event MilestoneAdded(uint256 indexed milestoneId, Phase phase, string title);
    event MilestoneCompleted(uint256 indexed milestoneId, uint256 timestamp);
    event PhaseUpdated(Phase indexed phase, bool completed);
    
    /// @notice Add milestone to roadmap
    function addMilestone(
        Phase _phase,
        string calldata _title,
        string calldata _description,
        uint256 _targetDate
    ) external returns (uint256);
    
    /// @notice Complete milestone
    function completeMilestone(uint256 _milestoneId) external;
    
    /// @notice Get milestone details
    function getMilestone(uint256 _milestoneId) external view returns (Milestone memory);
    
    /// @notice Get milestones by phase
    function getMilestonesByPhase(Phase _phase) external view returns (uint256[] memory);
    
    /// @notice Get all milestones
    function getAllMilestones() external view returns (uint256[] memory);
    
    /// @notice Check if phase is complete
    function isPhaseComplete(Phase _phase) external view returns (bool);
}
