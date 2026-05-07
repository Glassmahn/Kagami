// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiXTrigger
/// @notice Auto-kagami any X post you tag (repo #39)
interface IKagamiXTrigger {
    struct XPost {
        uint256 id;
        string postId;
        address tagger;
        string reflectionMetadataURI;
        bool reflected;
        uint256 reflectionId;
    }
    
    event XPostTagged(uint256 indexed postId, address indexed tagger, string postIdStr);
    event AutoKagamiFied(uint256 indexed postId, uint256 reflectionId);
    
    /// @notice Tag an X post to kagami-fy it
    function tagXPost(string calldata _postId, string calldata _metadataURI) external returns (uint256);
    
    /// @notice Auto-process tagged posts (called by oracle/bot)
    function processTaggedPost(uint256 _postId) external;
    
    /// @notice Get X post details
    function getXPost(uint256 _postId) external view returns (XPost memory);
    
    /// @notice Get all posts tagged by user
    function getUserTaggedPosts(address _user) external view returns (uint256[] memory);
    
    /// @notice Check if post is already kagami-fied
    function isPostKagamiFied(uint256 _postId) external view returns (bool);
}
