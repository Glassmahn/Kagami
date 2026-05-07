// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiRwaGateway
/// @notice Real-world assets as premium shards (repo #54)
interface IKagamiRwaGateway {
    struct RWA {
        uint256 id;
        uint256 reflectionId;
        string assetType; // "real-estate", "commodity", "bond", etc.
        uint256 valueUSD;
        address owner;
        bool verified;
        uint256 tokenizedAt;
    }
    
    event RWARegistered(uint256 indexed rwaId, uint256 indexed reflectionId, string assetType);
    event RWATokenized(uint256 indexed rwaId, uint256 reflectionId);
    event RWAVerified(uint256 indexed rwaId);
    
    /// @notice Register real-world asset
    function registerRWA(
        uint256 _reflectionId,
        string calldata _assetType,
        uint256 _valueUSD
    ) external returns (uint256 rwaId);
    
    /// @notice Tokenize RWA into shard
    function tokenizeRWA(uint256 _rwaId) external;
    
    /// @notice Verify RWA (admin only)
    function verifyRWA(uint256 _rwaId) external;
    
    /// @notice Get RWA details
    function getRWA(uint256 _rwaId) external view returns (RWA memory);
    
    /// @notice Get all RWAs for reflection
    function getReflectionRWAs(uint256 _reflectionId) external view returns (uint256[] memory);
    
    /// @notice Check if RWA is verified
    function isVerified(uint256 _rwaId) external view returns (bool);
}
