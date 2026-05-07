// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiNotifications
/// @notice Real-time shard performance alerts (repo #40)
contract KagamiNotifications is Ownable {
    struct Notification {
        uint256 id;
        uint256 reflectionId;
        address user;
        string notificationType; // "revenue", "liquidation", "milestone", etc.
        string message;
        uint256 timestamp;
        bool read;
    }
    
    uint256 public notificationCount;
    mapping(uint256 => Notification) public notifications;
    mapping(address => uint256[]) public userNotifications;
    mapping(uint256 => uint256[]) public reflectionNotifications;
    
    event NotificationCreated(
        uint256 indexed notificationId,
        address indexed user,
        uint256 indexed reflectionId,
        string notificationType
    );
    event NotificationRead(uint256 indexed notificationId, address indexed user);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Create notification for user
    function createNotification(
        address _user,
        uint256 _reflectionId,
        string calldata _type,
        string calldata _message
    ) external onlyOwner returns (uint256) {
        notificationCount++;
        
        notifications[notificationCount] = Notification({
            id: notificationCount,
            reflectionId: _reflectionId,
            user: _user,
            notificationType: _type,
            message: _message,
            timestamp: block.timestamp,
            read: false
        });
        
        userNotifications[_user].push(notificationCount);
        reflectionNotifications[_reflectionId].push(notificationCount);
        
        emit NotificationCreated(notificationCount, _user, _reflectionId, _type);
        return notificationCount;
    }
    
    /// @notice Mark notification as read
    function markAsRead(uint256 _notificationId) external {
        Notification storage n = notifications[_notificationId];
        require(n.user == msg.sender, "Not your notification");
        require(!n.read, "Already read");
        
        n.read = true;
        emit NotificationRead(_notificationId, msg.sender);
    }
    
    /// @notice Get unread notifications for user
    function getUnreadNotifications(address _user) 
        external view returns (uint256[] memory) {
        uint256[] storage all = userNotifications[_user];
        uint256 unreadCount = 0;
        
        for (uint256 i = 0; i < all.length; i++) {
            if (!notifications[all[i]].read) unreadCount++;
        }
        
        uint256[] memory unread = new uint256[](unreadCount);
        uint256 index = 0;
        for (uint256 i = 0; i < all.length; i++) {
            if (!notifications[all[i]].read) {
                unread[index++] = all[i];
            }
        }
        
        return unread;
    }
    
    /// @notice Get notification details
    function getNotification(uint256 _notificationId) 
        external view returns (Notification memory) {
        return notifications[_notificationId];
    }
}
