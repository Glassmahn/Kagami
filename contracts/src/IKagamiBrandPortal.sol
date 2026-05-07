// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiBrandPortal
/// @notice Brands drop campaigns → instant kagamis (repo #37)
interface IKagamiBrandPortal {
    struct Campaign {
        uint256 id;
        address brand;
        string campaignName;
        string metadataURI;
        uint256 budget;
        uint256 reflectionsCreated;
        bool active;
        uint256 startTime;
        uint256 endTime;
    }
    
    event CampaignCreated(uint256 indexed campaignId, address indexed brand, string name);
    event ReflectionCreatedFromCampaign(uint256 indexed campaignId, uint256 reflectionId);
    event CampaignEnded(uint256 indexed campaignId, uint256 totalReflections);
    
    /// @notice Create a brand campaign
    function createCampaign(
        string calldata _name,
        string calldata _metadataURI,
        uint256 _budget,
        uint256 _duration
    ) external payable returns (uint256) {
        require(msg.value >= _budget, "Insufficient budget");
        
        // Implementation would create campaign struct
        // Returns campaign ID
    }
    
    /// @notice Create reflection from campaign
    function createReflectionFromCampaign(uint256 _campaignId, string calldata _ideaURI) 
        external returns (uint256);
    
    /// @notice End campaign and refund remaining budget
    function endCampaign(uint256 _campaignId) external;
    
    /// @notice Get campaign details
    function getCampaign(uint256 _campaignId) external view returns (Campaign memory);
    
    /// @notice Check if caller is verified brand
    function isVerifiedBrand(address _brand) external view returns (bool);
}
