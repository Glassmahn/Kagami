// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiDashboard
/// @notice Personal reflection portfolio + live P&L (repo #34)
interface IKagamiDashboard {
    struct ReflectionPnL {
        uint256 reflectionId;
        uint256 initialValue;
        uint256 currentValue;
        uint256 revenue;
        int256 pnl; // profit or loss
        uint256 percentageChange;
    }
    
    event DashboardUpdated(address indexed user, uint256 reflectionCount);
    event PnLUpdated(uint256 indexed reflectionId, int256 pnl);
    
    /// @notice Get all reflections for a user with P&L
    function getUserDashboard(address _user) 
        external view returns (ReflectionPnL[] memory);
    
    /// @notice Get single reflection P&L
    function getReflectionPnL(uint256 _reflectionId) 
        external view returns (ReflectionPnL memory);
    
    /// @notice Update reflection value (called by oracle/engine)
    function updateReflectionValue(uint256 _reflectionId, uint256 _newValue) external;
    
    /// @notice Get total portfolio value for user
    function getTotalPortfolioValue(address _user) 
        external view returns (uint256 totalValue, int256 totalPnL);
}
