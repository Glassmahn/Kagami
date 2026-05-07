// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiEvents
/// @notice Onchain event drops + POAPs (repo #92)
contract KagamiEvents is Ownable {
    struct Event {
        uint256 id;
        string name;
        string description;
        uint256 startTime;
        uint256 endTime;
        bool active;
        uint256 reflectionId;
    }
    
    struct POAP {
        uint256 tokenId;
        uint256 eventId;
        address recipient;
        uint256 mintedAt;
    }
    
    uint256 public eventCount;
    uint256 public poapCount;
    
    mapping(uint256 => Event) public events;
    mapping(uint256 => POAP) public poaps;
    mapping(uint256 => uint256[]) public eventPOAPs;
    mapping(address => uint256[]) public userPOAPs;
    
    event EventCreated(uint256 indexed eventId, string name, uint256 reflectionId);
    event POAPMinted(uint256 indexed tokenId, uint256 indexed eventId, address recipient);
    event EventEnded(uint256 indexed eventId);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Create an onchain event
    function createEvent(
        string calldata _name,
        string calldata _description,
        uint256 _duration,
        uint256 _reflectionId
    ) external onlyOwner returns (uint256) {
        eventCount++;
        
        events[eventCount] = Event({
            id: eventCount,
            name: _name,
            description: _description,
            startTime: block.timestamp,
            endTime: block.timestamp + _duration,
            active: true,
            reflectionId: _reflectionId
        });
        
        emit EventCreated(eventCount, _name, _reflectionId);
        return eventCount;
    }
    
    /// @notice Mint POAP for event attendance
    function mintPOAP(uint256 _eventId) external returns (uint256) {
        Event storage evt = events[_eventId];
        require(evt.active, "Event not active");
        require(block.timestamp <= evt.endTime, "Event ended");
        
        poapCount++;
        poaps[poapCount] = POAP({
            tokenId: poapCount,
            eventId: _eventId,
            recipient: msg.sender,
            mintedAt: block.timestamp
        });
        
        eventPOAPs[_eventId].push(poapCount);
        userPOAPs[msg.sender].push(poapCount);
        
        emit POAPMinted(poapCount, _eventId, msg.sender);
        return poapCount;
    }
    
    /// @notice End event
    function endEvent(uint256 _eventId) external onlyOwner {
        events[_eventId].active = false;
        emit EventEnded(_eventId);
    }
    
    /// @notice Get event details
    function getEvent(uint256 _eventId) external view returns (Event memory) {
        return events[_eventId];
    }
    
    /// @notice Get POAPs for event
    function getEventPOAPs(uint256 _eventId) external view returns (uint256[] memory) {
        return eventPOAPs[_eventId];
    }
    
    /// @notice Get user's POAPs
    function getUserPOAPs(address _user) external view returns (uint256[] memory) {
        return userPOAPs[_user];
    }
}
