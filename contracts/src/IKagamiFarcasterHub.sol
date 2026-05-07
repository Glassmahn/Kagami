// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiFarcasterHub
/// @notice Native Farcaster identity & frames (repo #48)
interface IKagamiFarcasterHub {
    struct FarcasterUser {
        uint256 fid;
        address wallet;
        string username;
        bool verified;
        uint256 kagamiCount;
    }
    
    event UserRegistered(uint256 indexed fid, address indexed wallet, string username);
    event FrameCast(uint256 indexed fid, uint256 reflectionId, string castHash);
    event IdentityVerified(uint256 indexed fid, address indexed wallet);
    
    /// @notice Register Farcaster identity
    function registerFarcasterUser(
        uint256 _fid,
        string calldata _username
    ) external returns (bool);
    
    /// @notice Cast a frame (create reflection from Farcaster)
    function castFrame(uint256 _fid, string calldata _reflectionMetadata) 
        external returns (uint256 reflectionId);
    
    /// @notice Verify Farcaster identity with wallet
    function verifyIdentity(uint256 _fid, address _wallet) external;
    
    /// @notice Get Farcaster user details
    function getFarcasterUser(uint256 _fid) external view returns (FarcasterUser memory);
    
    /// @notice Get user's reflections
    function getUserReflections(uint256 _fid) external view returns (uint256[] memory);
    
    /// @notice Check if FID is verified
    function isVerified(uint256 _fid) external view returns (bool);
}
