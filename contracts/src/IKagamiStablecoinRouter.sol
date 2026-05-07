// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiStablecoinRouter
/// @notice USDC-first everywhere (repo #53)
interface IKagamiStablecoinRouter {
    event StablecoinRouted(
        uint256 indexed reflectionId,
        address indexed token,
        uint256 amount,
        string targetProtocol
    );
    event USDCReceived(uint256 indexed reflectionId, uint256 amount);
    
    /// @notice Route any stablecoin to USDC
    function routeToUSDC(uint256 _reflectionId, address _fromToken, uint256 _amount) 
        external returns (uint256 usdcAmount);
    
    /// @notice Receive USDC into reflection
    function receiveUSDC(uint256 _reflectionId) external payable;
    
    /// @notice Get USDC balance for reflection
    function getUSDCBalance(uint256 _reflectionId) external view returns (uint256);
    
    /// @notice Get supported stablecoins
    function getSupportedStablecoins() external view returns (address[] memory);
    
    /// @notice Check if token is supported stablecoin
    function isSupportedStablecoin(address _token) external view returns (bool);
}
