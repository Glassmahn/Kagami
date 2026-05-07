// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiSecurity
/// @notice Bug bounty + emergency pause (repo #80)
interface IKagamiSecurity {
    struct BugReport {
        uint256 id;
        address reporter;
        string component;
        string severity; // "low", "medium", "high", "critical"
        string descriptionURI;
        bool validated;
        bool rewarded;
    }
    
    struct EmergencyPause {
        uint256 id;
        string component;
        string reason;
        uint256 pausedAt;
        bool resolved;
    }
    
    event BugReported(uint256 indexed reportId, address indexed reporter, string component);
    event BugValidated(uint256 indexed reportId, uint256 reward);
    event EmergencyPaused(string component, string reason);
    event EmergencyUnpaused(string component);
    
    /// @notice Report a bug
    function reportBug(
        string calldata _component,
        string calldata _severity,
        string calldata _descriptionURI
    ) external returns (uint256);
    
    /// @notice Validate bug and reward reporter
    function validateBug(uint256 _reportId, uint256 _reward) external;
    
    /// @notice Emergency pause a component
    function emergencyPause(string calldata _component, string calldata _reason) external;
    
    /// @notice Unpause a component
    function emergencyUnpause(string calldata _component) external;
    
    /// @notice Get bug report
    function getBugReport(uint256 _reportId) external view returns (BugReport memory);
    
    /// @notice Get all active pauses
    function getActivePauses() external view returns (uint256[] memory);
}
