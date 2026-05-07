// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiMemes
/// @notice Official meme factory + viral content (repo #91)
contract KagamiMemes is Ownable {
    struct Meme {
        uint256 id;
        string title;
        string ipfsImageHash;
        address creator;
        uint256 reflectionId;
        uint256 shares;
        bool viral;
    }
    
    uint256 public memeCount;
    mapping(uint256 => Meme) public memes;
    mapping(address => uint256[]) public creatorMemes;
    
    event MemeCreated(uint256 indexed memeId, address indexed creator, string title);
    event MemeShared(uint256 indexed memeId, address indexed user);
    event MemeWentViral(uint256 indexed memeId, uint256 shareCount);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Create a meme
    function createMeme(
        string calldata _title,
        string calldata _ipfsImageHash,
        uint256 _reflectionId
    ) external returns (uint256) {
        memeCount++;
        
        memes[memeCount] = Meme({
            id: memeCount,
            title: _title,
            ipfsImageHash: _ipfsImageHash,
            creator: msg.sender,
            reflectionId: _reflectionId,
            shares: 0,
            viral: false
        });
        
        creatorMemes[msg.sender].push(memeCount);
        
        emit MemeCreated(memeCount, msg.sender, _title);
        return memeCount;
    }
    
    /// @notice Share meme (viral tracking)
    function shareMeme(uint256 _memeId) external {
        Meme storage meme = memes[_memeId];
        meme.shares++;
        
        emit MemeShared(_memeId, msg.sender);
        
        // Check if viral (shares > 1000)
        if (meme.shares > 1000 && !meme.viral) {
            meme.viral = true;
            emit MemeWentViral(_memeId, meme.shares);
        }
    }
    
    /// @notice Get meme details
    function getMeme(uint256 _memeId) external view returns (Meme memory) {
        return memes[_memeId];
    }
    
    /// @notice Get viral memes
    function getViralMemes() external view returns (uint256[] memory) {
        uint256[] memory temp = new uint256[](memeCount);
        uint256 count = 0;
        
        for (uint256 i = 1; i <= memeCount; i++) {
            if (memes[i].viral) {
                temp[count++] = i;
            }
        }
        
        // Trim array
        uint256[] memory viral = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            viral[i] = temp[i];
        }
        
        return viral;
    }
    
    /// @notice Check if meme is viral (shares > 1000)
    function isViral(uint256 _memeId) external view returns (bool) {
        return memes[_memeId].viral;
    }
    
    /// @notice Get memes by creator
    function getCreatorMemes(address _creator) 
        external view returns (uint256[] memory) {
        return creatorMemes[_creator];
    }
}
