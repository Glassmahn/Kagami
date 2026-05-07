// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AgentSubscriptions
/// @notice Pay agents to manage your kagamis (repo #22)
contract AgentSubscriptions is Ownable {
    struct Subscription {
        uint256 id;
        uint256 agentId;
        address subscriber;
        uint256 kagamiId;
        uint256 monthlyFee; // in wei
        uint256 startDate;
        uint256 lastPayment;
        bool active;
    }
    
    uint256 public subscriptionCount;
    mapping(uint256 => Subscription) public subscriptions;
    mapping(uint256 => uint256[]) public agentSubscriptions;
    mapping(address => uint256[]) public subscriberSubscriptions;
    
    event Subscribed(uint256 indexed subId, uint256 indexed agentId, address subscriber);
    event PaymentMade(uint256 indexed subId, uint256 amount, uint256 timestamp);
    event SubscriptionCancelled(uint256 indexed subId);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Subscribe to an agent to manage your kagami
    function subscribe(uint256 _agentId, uint256 _kagamiId, uint256 _monthlyFee) 
        external payable returns (uint256) {
        require(msg.value >= _monthlyFee, "Insufficient payment");
        
        subscriptionCount++;
        subscriptions[subscriptionCount] = Subscription({
            id: subscriptionCount,
            agentId: _agentId,
            subscriber: msg.sender,
            kagamiId: _kagamiId,
            monthlyFee: _monthlyFee,
            startDate: block.timestamp,
            lastPayment: block.timestamp,
            active: true
        });
        
        agentSubscriptions[_agentId].push(subscriptionCount);
        subscriberSubscriptions[msg.sender].push(subscriptionCount);
        
        emit Subscribed(subscriptionCount, _agentId, msg.sender);
        return subscriptionCount;
    }
    
    /// @notice Pay monthly fee
    function payMonthly(uint256 _subscriptionId) external payable {
        Subscription storage sub = subscriptions[_subscriptionId];
        require(sub.active, "Subscription not active");
        require(msg.value >= sub.monthlyFee, "Insufficient payment");
        require(block.timestamp >= sub.lastPayment + 30 days, "Too early");
        
        sub.lastPayment = block.timestamp;
        emit PaymentMade(_subscriptionId, msg.value, block.timestamp);
    }
    
    /// @notice Cancel subscription
    function cancelSubscription(uint256 _subscriptionId) external {
        Subscription storage sub = subscriptions[_subscriptionId];
        require(msg.sender == sub.subscriber, "Not subscriber");
        require(sub.active, "Already cancelled");
        
        sub.active = false;
        emit SubscriptionCancelled(_subscriptionId);
    }
}
