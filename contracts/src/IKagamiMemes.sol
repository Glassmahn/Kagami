// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiMemes
/// @notice Official meme factory + viral content (repo #91)
interface IKagamiMemes {
    struct Meme {
        uint256 id;
        string title;
        string ipfsImageHash;
        address creator;
        uint256 reflectionId;
        uint256 shares;
        bool viral;
    }
    
    event MemeCreated(uint256 indexed memeId, address indexed creator, string title);
    event MemeShared(uint256 indexed memeId, address indexed user);
    event MemeWentViral(uint256 indexed memeId, uint256 shareCount);
    
    /// @notice Create a meme
    function createMeme(
        string calldata _title,
        string calldata _ipfsImageHash,
        uint256 _reflectionId
    ) external returns (uint256);
    
    /// @notice Share meme (viral tracking)
    function shareMeme(uint256 _memeId) external;
    
    /// @notice Get meme details
    function getMeme(uint256 _memeId) external view returns (Meme memory);
    
    /// @notice Get viral memes
    function getViralMemes() external view returns (uint256[] memory);
    
    /// @notice Check if meme is viral (shares > 1000)
    function isViral(uint256 _memeId) external view returns (bool);
}
