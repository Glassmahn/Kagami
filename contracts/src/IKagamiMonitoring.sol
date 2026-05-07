// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiMonitoring
/// @notice Alerting + uptime system (repo #79)
interface IKagamiMonitoring {
    struct Alert {
        uint256 id;
        string component;
        string severity; // "low", "medium", "high", "critical"
        string message;
        uint256 timestamp;
        bool resolved;
    }
    
    struct UptimeRecord {
        string component;
        uint256 lastCheck;
        bool isUp;
        uint256 uptimePercentage; // basis points (10000 = 100%)
    }
    
    event AlertTriggered(uint256 indexed alertId, string component, string severity);
    event AlertResolved(uint256 indexed alertId, uint256 timestamp);
    event UptimeUpdated(string component, bool isUp, uint256 uptimePercentage);
    
    /// @notice Trigger an alert
    function triggerAlert(
        string calldata _component,
        string calldata _severity,
        string calldata _message
    ) external returns (uint256);
    
    /// @notice Resolve an alert
    function resolveAlert(uint256 _alertId) external;
    
    /// @notice Update uptime record
    function updateUptime(string calldata _component, bool _isUp) external;
    
    /// @notice Get active alerts
    function getActiveAlerts() external view returns (uint256[] memory);
    
    /// @notice Get uptime for component
    function getUptime(string calldata _component) external view returns (UptimeRecord memory);
    
    /// @notice Get all components monitored
    function getMonitoredComponents() external view returns (string[] memory);
}
