// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IOracleAdapter
/// @notice Chainlink/Pyth + cultural signal oracles (repo #5)
interface IOracleAdapter {
    event PriceUpdated(bytes32 indexed feedId, int256 price, uint256 timestamp);
    event CulturalSignalReceived(bytes32 indexed signalId, uint256 intensity, uint256 timestamp);
    
    /// @notice Get latest price from oracle
    function getPrice(bytes32 _feedId) external view returns (int256 price, uint256 timestamp);
    
    /// @notice Get cultural signal intensity (0-100 scale)
    function getCulturalSignal(bytes32 _signalId) external view returns (uint256 intensity, uint256 timestamp);
    
    /// @notice Check if a signal is trending
    function isTrending(bytes32 _signalId) external view returns (bool);
    
    /// @notice Get combined reflection score (price * cultural weight)
    function getReflectionScore(bytes32 _feedId, bytes32 _signalId) 
        external view returns (uint256 score);
}
