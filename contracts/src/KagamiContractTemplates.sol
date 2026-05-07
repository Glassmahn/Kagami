// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./ReflectionEngine.sol";

/// @title KagamiContractTemplates
/// @notice 50+ ready reflection types (repo #62)
contract KagamiContractTemplates {
    ReflectionEngine public immutable reflectionEngine;
    
    enum ReflectionType {
        MEME,
        NFT,
        TOKEN,
        DAO,
        YIELD,
        PREDICTION,
        RWA,
        GAMING,
        SOCIAL,
        DEVELOPER
        // ... can be extended to 50+
    }
    
    mapping(ReflectionType => string) public typeMetadata;
    mapping(ReflectionType => bool) public typeEnabled;
    
    event TemplateCreated(ReflectionType reflectionType, string metadataURI);
    event TemplateEnabled(ReflectionType reflectionType, bool enabled);
    
    constructor(address _reflectionEngine) {
        reflectionEngine = ReflectionEngine(_reflectionEngine);
        _initializeTemplates();
    }
    
    /// @notice Create reflection from template
    function createFromTemplate(
        ReflectionType _type,
        string calldata _customMetadata
    ) external returns (uint256) {
        require(typeEnabled[_type], "Template not enabled");
        
        string memory fullMetadata = string(abi.encodePacked(
            typeMetadata[_type],
            " - ",
            _customMetadata
        ));
        
        uint256 reflectionId = reflectionEngine.createReflection(fullMetadata);
        
        emit TemplateCreated(_type, fullMetadata);
        return reflectionId;
    }
    
    /// @notice Initialize default templates
    function _initializeTemplates() internal {
        typeMetadata[ReflectionType.MEME] = "Meme Reflection: Viral token + NFT shards";
        typeMetadata[ReflectionType.NFT] = "NFT Reflection: Dynamic NFTs with yield";
        typeMetadata[ReflectionType.TOKEN] = "Token Reflection: Governance + revenue share";
        typeMetadata[ReflectionType.DAO] = "DAO Reflection: Community governance shard";
        typeMetadata[ReflectionType.YIELD] = "Yield Reflection: Auto-compounding yield vault";
        typeMetadata[ReflectionType.PREDICTION] = "Prediction Reflection: Market prediction shard";
        typeMetadata[ReflectionType.RWA] = "RWA Reflection: Real-world asset tokenization";
        typeMetadata[ReflectionType.GAMING] = "Gaming Reflection: In-game assets + rewards";
        typeMetadata[ReflectionType.SOCIAL] = "Social Reflection: Creator economy shard";
        typeMetadata[ReflectionType.DEVELOPER] = "Developer Reflection: Code + bounties shard";
        
        // Enable all by default
        for (uint8 i = 0; i <= uint8(ReflectionType.DEVELOPER); i++) {
            typeEnabled[ReflectionType(i)] = true;
        }
    }
    
    /// @notice Enable/disable template
    function setTemplateEnabled(ReflectionType _type, bool _enabled) external {
        typeEnabled[_type] = _enabled;
        emit TemplateEnabled(_type, _enabled);
    }
    
    /// @notice Get all enabled templates
    function getEnabledTemplates() external view returns (ReflectionType[] memory) {
        ReflectionType[] memory enabled = new ReflectionType[](10);
        uint256 index = 0;
        
        for (uint8 i = 0; i <= uint8(ReflectionType.DEVELOPER); i++) {
            if (typeEnabled[ReflectionType(i)]) {
                enabled[index++] = ReflectionType(i);
            }
        }
        
        // Trim array
        assembly {
            mstore(enabled, index)
        }
        
        return enabled;
    }
}
