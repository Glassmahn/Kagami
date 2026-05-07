// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AgentMarketplace
/// @notice Buy/sell fully trained reflection-managing agents (repo #25)
contract AgentMarketplace is Ownable {
    struct Listing {
        uint256 id;
        uint256 agentId;
        address seller;
        uint256 price; // in wei
        bool active;
        uint256 listedAt;
        string metadataURI;
    }
    
    uint256 public listingCount;
    mapping(uint256 => Listing) public listings;
    mapping(uint256 => uint256[]) public agentListings;
    
    event AgentListed(uint256 indexed listingId, uint256 indexed agentId, uint256 price);
    event AgentSold(uint256 indexed listingId, address buyer, uint256 price);
    event ListingCancelled(uint256 indexed listingId);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice List an agent for sale
    function listAgent(uint256 _agentId, uint256 _price, string calldata _metadataURI) 
        external returns (uint256) {
        listingCount++;
        
        listings[listingCount] = Listing({
            id: listingCount,
            agentId: _agentId,
            seller: msg.sender,
            price: _price,
            active: true,
            listedAt: block.timestamp,
            metadataURI: _metadataURI
        });
        
        agentListings[_agentId].push(listingCount);
        
        emit AgentListed(listingCount, _agentId, _price);
        return listingCount;
    }
    
    /// @notice Buy a listed agent
    function buyAgent(uint256 _listingId) external payable {
        Listing storage listing = listings[_listingId];
        require(listing.active, "Listing not active");
        require(msg.value >= listing.price, "Insufficient payment");
        
        listing.active = false;
        payable(listing.seller).transfer(listing.price);
        
        emit AgentSold(_listingId, msg.sender, listing.price);
        
        // Refund excess
        if (msg.value > listing.price) {
            payable(msg.sender).transfer(msg.value - listing.price);
        }
    }
    
    /// @notice Cancel listing
    function cancelListing(uint256 _listingId) external {
        Listing storage listing = listings[_listingId];
        require(msg.sender == listing.seller, "Not seller");
        require(listing.active, "Not active");
        
        listing.active = false;
        emit ListingCancelled(_listingId);
    }
    
    /// @notice Get active listings for an agent
    function getAgentListings(uint256 _agentId) external view returns (uint256[] memory) {
        return agentListings[_agentId];
    }
}
