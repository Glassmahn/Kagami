// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiMobile
/// @notice React Native app with Base smart wallet (repo #32)
interface IKagamiMobile {
    event MobileReflectionCreated(uint256 indexed reflectionId, address indexed user, string deviceId);
    event MobileWalletConnected(address indexed user, string walletType);
    event PushNotificationSent(uint256 indexed reflectionId, string message);
    
    /// @notice Create reflection from mobile app
    function mobileCreateReflection(
        string calldata _metadataURI,
        string calldata _deviceId
    ) external returns (uint256);
    
    /// @notice Connect mobile wallet (Coinbase Smart Wallet)
    function connectMobileWallet(string calldata _walletType) external;
    
    /// @notice Send push notification for reflection update
    function sendPushNotification(uint256 _reflectionId, string calldata _message) external;
    
    /// @notice Get mobile-specific reflection feed
    function getMobileFeed(string calldata _deviceId) 
        external view returns (uint256[] memory reflectionIds);
    
    /// @notice Check if mobile wallet is connected
    function isMobileWalletConnected(address _user) external view returns (bool);
}
