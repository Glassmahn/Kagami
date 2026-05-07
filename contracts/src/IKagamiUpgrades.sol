// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiUpgrades
/// @notice Transparent proxy + governance execution (repo #81)
interface IKagamiUpgrades {
    struct Upgrade {
        uint256 id;
        string component;
        string newImplementation;
        uint256 proposedAt;
        uint256 executedAt;
        bool executed;
        uint256 proposalId; // links to governance
    }
    
    event UpgradeProposed(uint256 indexed upgradeId, string component, string newImpl);
    event UpgradeExecuted(uint256 indexed upgradeId, string component, uint256 timestamp);
    event UpgraderUpdated(address indexed newUpgrader);
    
    /// @notice Propose an upgrade (governance)
    function proposeUpgrade(
        string calldata _component,
        string calldata _newImplementation
    ) external returns (uint256);
    
    /// @notice Execute upgrade after governance approval
    function executeUpgrade(uint256 _upgradeId) external;
    
    /// @notice Get upgrade details
    function getUpgrade(uint256 _upgradeId) external view returns (Upgrade memory);
    
    /// @notice Get all upgrades for component
    function getComponentUpgrades(string calldata _component) 
        external view returns (uint256[] memory);
    
    /// @notice Check if component is upgradeable
    function isUpgradeable(string calldata _component) external view returns (bool);
    
    /// @notice Update upgrader address (admin)
    function setUpgrader(address _newUpgrader) external;
}
