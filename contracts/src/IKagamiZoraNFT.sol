// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiZoraNFT
/// @notice Auto-mint shards as dynamic NFTs (repo #50)
interface IKagamiZoraNFT {
    struct DynamicNFT {
        uint256 tokenId;
        uint256 reflectionId;
        string metadataURI;
        uint256 lastUpdate;
        uint256 rarityScore;
    }
    
    event NFTMinted(uint256 indexed tokenId, uint256 indexed reflectionId, address indexed owner);
    event MetadataUpdated(uint256 indexed tokenId, string newMetadataURI, uint256 timestamp);
    event RarityUpdated(uint256 indexed tokenId, uint256 newRarityScore);
    
    /// @notice Auto-mint shard as NFT
    function mintShardNFT(uint256 _reflectionId, string calldata _metadataURI) 
        external returns (uint256 tokenId);
    
    /// @notice Update NFT metadata dynamically
    function updateMetadata(uint256 _tokenId, string calldata _newMetadataURI) external;
    
    /// @notice Update rarity score based on performance
    function updateRarity(uint256 _tokenId, uint256 _newScore) external;
    
    /// @notice Get NFT details
    function getNFT(uint256 _tokenId) external view returns (DynamicNFT memory);
    
    /// @notice Get all NFTs for reflection
    function getReflectionNFTs(uint256 _reflectionId) 
        external view returns (uint256[] memory tokenIds);
    
    /// @notice Check if reflection has NFT
    function hasNFT(uint256 _reflectionId) external view returns (bool);
}
