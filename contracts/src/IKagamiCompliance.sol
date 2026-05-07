// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiCompliance
/// @notice Templates for RWA shards (repo #83)
interface IKagamiCompliance {
    struct ComplianceTemplate {
        string assetType; // "real-estate", "commodity", "bond", etc.
        string jurisdiction;
        bool kycRequired;
        bool amlRequired;
        uint256 minInvestment;
        bool approved;
    }
    
    struct AssetCompliance {
        uint256 rwaId;
        string templateType;
        bool kycPassed;
        bool amlPassed;
        bool compliant;
    }
    
    event TemplateCreated(string indexed assetType, string jurisdiction);
    event ComplianceChecked(uint256 indexed rwaId, bool compliant);
    event AssetApproved(uint256 indexed rwaId);
    
    /// @notice Create compliance template
    function createTemplate(
        string calldata _assetType,
        string calldata _jurisdiction,
        bool _kycRequired,
        bool _amlRequired,
        uint256 _minInvestment
    ) external returns (string memory);
    
    /// @notice Check compliance for RWA
    function checkCompliance(uint256 _rwaId, string calldata _templateType) 
        external returns (bool);
    
    /// @notice Approve asset after compliance
    function approveAsset(uint256 _rwaId) external;
    
    /// @notice Get compliance template
    function getTemplate(string calldata _assetType, string calldata _jurisdiction) 
        external view returns (ComplianceTemplate memory);
    
    /// @notice Get asset compliance status
    function getAssetCompliance(uint256 _rwaId) 
        external view returns (AssetCompliance memory);
    
    /// @notice Check if asset is compliant
    function isCompliant(uint256 _rwaId) external view returns (bool);
}
