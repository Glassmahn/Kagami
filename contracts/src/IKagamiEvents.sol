// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiEvents
/// @notice Onchain event drops + POAPs (repo #92)
interface IKagamiEvents {
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
    
    event EventCreated(uint256 indexed eventId, string name, uint256 reflectionId);
    event POAPMinted(uint256 indexed tokenId, uint256 indexed eventId, address recipient);
    event EventEnded(uint256 indexed eventId);
    
    /// @notice Create an onchain event
    function createEvent(
        string calldata _name,
        string calldata _description,
        uint256 _duration,
        uint256 _reflectionId
    ) external returns (uint256);
    
    /// @notice Mint POAP for event attendance
    function mintPOAP(uint256 _eventId) external returns (uint256);
    
    /// @notice End event
    function endEvent(uint256 _eventId) external;
    
    /// @notice Get event details
    function getEvent(uint256 _eventId) external view returns (Event memory);
    
    /// @notice Get POAPs for event
    function getEventPOAPs(uint256 _eventId) external view returns (uint256[] memory);
    
    /// @notice Get user's POAPs
    function getUserPOAPs(address _user) external view returns (uint256[] memory);
}
