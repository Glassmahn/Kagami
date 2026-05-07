// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiEmbed
/// @notice One-line widget to kagami-ify any website (repo #33)
interface IKagamiEmbed {
    event EmbedAdded(bytes32 indexed siteId, string domain, address indexed owner);
    event ReflectionEmbedded(uint256 indexed reflectionId, bytes32 indexed siteId);
    event EmbedClicked(bytes32 indexed siteId, uint256 reflectionId, address indexed user);
    
    /// @notice Register a website for embed
    function registerSite(string calldata _domain) external returns (bytes32);
    
    /// @notice Embed a reflection on a registered site
    function embedReflection(uint256 _reflectionId, bytes32 _siteId) external;
    
    /// @notice Track embed click (user views embedded reflection)
    function trackClick(bytes32 _siteId, uint256 _reflectionId) external;
    
    /// @notice Get all embeds for a reflection
    function getReflectionEmbeds(uint256 _reflectionId) 
        external view returns (bytes32[] memory siteIds);
    
    /// @notice Check if domain is registered
    function isRegisteredSite(bytes32 _siteId) external view returns (bool);
    
    /// @notice Get site info
    function getSiteInfo(bytes32 _siteId) 
        external view returns (string memory domain, address owner, uint256 embedCount);
}
