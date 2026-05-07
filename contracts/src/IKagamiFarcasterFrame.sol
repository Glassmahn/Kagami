// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiFarcasterFrame
/// @notice Kagami any Farcaster cast in one tap (repo #38)
interface IKagamiFarcasterFrame {
    struct Cast {
        uint256 id;
        address caster;
        string contentURI;
        uint256 timestamp;
        bool kagamiFied;
        uint256 reflectionId;
    }
    
    event CastKagamiFied(uint256 indexed castId, address indexed caster, uint256 reflectionId);
    event FrameViewed(uint256 indexed castId, address viewer);
    
    /// @notice Kagami a Farcaster cast (create reflection from cast)
    function kagamiFyCast(
        string calldata _castContentURI,
        string calldata _metadataURI
    ) external returns (uint256);
    
    /// @notice View frame analytics
    function viewFrame(uint256 _castId) external;
    
    /// @notice Get cast details
    function getCast(uint256 _castId) external view returns (Cast memory);
    
    /// @notice Get all kagami-fied casts by user
    function getUserKagamiFiedCasts(address _user) 
        external view returns (uint256[] memory castIds);
    
    /// @notice Check if cast is kagami-fied
    function isKagamiFied(uint256 _castId) external view returns (bool);
}
