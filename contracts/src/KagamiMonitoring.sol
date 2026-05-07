// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiMonitoring
/// @notice Alerting + uptime system (repo #79)
contract KagamiMonitoring is Ownable {
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
    
    uint256 public alertCount;
    uint256 public uptimeCount;
    
    mapping(uint256 => Alert) public alerts;
    mapping(string => UptimeRecord) public uptimeRecords;
    mapping(address => uint256[]) public userAlerts;
    
    event AlertTriggered(uint256 indexed alertId, string component, string severity);
    event AlertResolved(uint256 indexed alertId, uint256 timestamp);
    event UptimeUpdated(string component, bool isUp, uint256 uptimePercentage);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Trigger an alert
    function triggerAlert(
        string calldata _component,
        string calldata _severity,
        string calldata _message
    ) external onlyOwner returns (uint256) {
        alertCount++;
        
        alerts[alertCount] = Alert({
            id: alertCount,
            component: _component,
            severity: _severity,
            message: _message,
            timestamp: block.timestamp,
            resolved: false
        });
        
        userAlerts[msg.sender].push(alertCount);
        
        emit AlertTriggered(alertCount, _component, _severity);
        return alertCount;
    }
    
    /// @notice Resolve an alert
    function resolveAlert(uint256 _alertId) external onlyOwner {
        Alert storage alert = alerts[_alertId];
        require(alert.id > 0, "Alert not found");
        require(!alert.resolved, "Already resolved");
        
        alert.resolved = true;
        emit AlertResolved(_alertId, block.timestamp);
    }
    
    /// @notice Update uptime record
    function updateUptime(string calldata _component, bool _isUp) external onlyOwner {
        UptimeRecord storage record = uptimeRecords[_component];
        
        record.component = _component;
        record.lastCheck = block.timestamp;
        record.isUp = _isUp;
        
        // Simplified uptime calculation
        if (_isUp) {
            record.uptimePercentage = 10000; // 100%
        } else {
            record.uptimePercentage = 0;
        }
        
        emit UptimeUpdated(_component, _isUp, record.uptimePercentage);
    }
    
    /// @notice Get active alerts
    function getActiveAlerts() external view returns (uint256[] memory) {
        uint256[] memory temp = new uint256[](alertCount);
        uint256 count = 0;
        
        for (uint256 i = 1; i <= alertCount; i++) {
            if (!alerts[i].resolved) {
                temp[count++] = i;
            }
        }
        
        // Trim array
        uint256[] memory active = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            active[i] = temp[i];
        }
        
        return active;
    }
    
    /// @notice Get uptime for component
    function getUptime(string calldata _component) 
        external view returns (UptimeRecord memory) {
        return uptimeRecords[_component];
    }
    
    /// @notice Get all components monitored
    function getMonitoredComponents() external view returns (string[] memory) {
        // Simplified - return common components
        string[] memory components = new string[](5);
        components[0] = "KagamiCore";
        components[1] = "ReflectionEngine";
        components[2] = "SeedFactory";
        components[3] = "KagamiToken";
        components[4] = "KagamiRelayer";
        return components;
    }
    
    /// @notice Get alert details
    function getAlert(uint256 _alertId) external view returns (Alert memory) {
        return alerts[_alertId];
    }
    
    /// @notice Get user's alerts
    function getUserAlerts(address _user) external view returns (uint256[] memory) {
        return userAlerts[_user];
    }
}
