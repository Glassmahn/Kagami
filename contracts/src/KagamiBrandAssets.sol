// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiBrandAssets
/// @notice Logos, animations, Farcaster frame kit (repo #84)
contract KagamiBrandAssets is Ownable {
    struct Asset {
        uint256 id;
        string name;
        string assetType; // "logo", "animation", "frame-kit", "press-kit"
        string ipfsHash;
        bool active;
        uint256 uploadedAt;
    }
    
    uint256 public assetCount;
    mapping(uint256 => Asset) public assets;
    mapping(string => uint256[]) public assetsByType;
    
    event AssetUploaded(uint256 indexed assetId, string name, string assetType);
    event AssetUpdated(uint256 indexed assetId, string newIpfsHash);
    event AssetDeactivated(uint256 indexed assetId);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Upload brand asset
    function uploadAsset(
        string calldata _name,
        string calldata _assetType,
        string calldata _ipfsHash
    ) external onlyOwner returns (uint256) {
        assetCount++;
        
        assets[assetCount] = Asset({
            id: assetCount,
            name: _name,
            assetType: _assetType,
            ipfsHash: _ipfsHash,
            active: true,
            uploadedAt: block.timestamp
        });
        
        assetsByType[_assetType].push(assetCount);
        
        emit AssetUploaded(assetCount, _name, _assetType);
        return assetCount;
    }
    
    /// @notice Update asset IPFS hash
    function updateAsset(uint256 _assetId, string calldata _newIpfsHash) external onlyOwner {
        Asset storage asset = assets[_assetId];
        require(asset.active, "Asset not active");
        
        asset.ipfsHash = _newIpfsHash;
        emit AssetUpdated(_assetId, _newIpfsHash);
    }
    
    /// @notice Deactivate asset
    function deactivateAsset(uint256 _assetId) external onlyOwner {
        assets[_assetId].active = false;
        emit AssetDeactivated(_assetId);
    }
    
    /// @notice Get asset details
    function getAsset(uint256 _assetId) external view returns (Asset memory) {
        return assets[_assetId];
    }
    
    /// @notice Get assets by type
    function getAssetsByType(string calldata _assetType) 
        external view returns (uint256[] memory) {
        return assetsByType[_assetType];
    }
}
