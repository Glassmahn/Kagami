// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiCreatorStudio
/// @notice Creator dashboard + revenue streams (repo #36)
interface IKagamiCreatorStudio {
    struct CreatorProfile {
        address creator;
        uint256 totalReflections;
        uint256 totalRevenue;
        uint256 totalFollowers;
        bool verified;
    }
    
    struct RevenueStream {
        uint256 reflectionId;
        uint256 amount;
        uint256 timestamp;
        string source; // "shard", "nft", "yield", etc.
    }
    
    event CreatorRegistered(address indexed creator);
    event RevenueStreamAdded(uint256 indexed reflectionId, uint256 amount, string source);
    event CreatorVerified(address indexed creator);
    
    /// @notice Register as creator
    function registerCreator() external;
    
    /// @notice Add revenue stream to reflection
    function addRevenueStream(
        uint256 _reflectionId,
        uint256 _amount,
        string calldata _source
    ) external;
    
    /// @notice Get creator profile
    function getCreatorProfile(address _creator) 
        external view returns (CreatorProfile memory);
    
    /// @notice Get all revenue streams for a reflection
    function getRevenueStreams(uint256 _reflectionId) 
        external view returns (RevenueStream[] memory);
    
    /// @notice Verify creator (admin only)
    function verifyCreator(address _creator) external;
    
    /// @notice Check if address is verified creator
    function isVerifiedCreator(address _creator) external view returns (bool);
}
