// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiCompliance
/// @notice Templates for RWA shards (repo #83)
contract KagamiCompliance is Ownable {
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
    
    mapping(string => ComplianceTemplate) public templates;
    mapping(uint256 => AssetCompliance) public assetCompliance;
    string[] public templateTypes;
    
    event TemplateCreated(string indexed assetType, string jurisdiction);
    event ComplianceChecked(uint256 indexed rwaId, bool compliant);
    event AssetApproved(uint256 indexed rwaId);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Create compliance template
    function createTemplate(
        string calldata _assetType,
        string calldata _jurisdiction,
        bool _kycRequired,
        bool _amlRequired,
        uint256 _minInvestment
    ) external onlyOwner {
        templates[_assetType] = ComplianceTemplate({
            assetType: _assetType,
            jurisdiction: _jurisdiction,
            kycRequired: _kycRequired,
            amlRequired: _amlRequired,
            minInvestment: _minInvestment,
            approved: false
        });
        
        templateTypes.push(_assetType);
        
        emit TemplateCreated(_assetType, _jurisdiction);
    }
    
    /// @notice Approve template
    function approveTemplate(string calldata _assetType) external onlyOwner {
        templates[_assetType].approved = true;
    }
    
    /// @notice Check compliance for RWA
    function checkCompliance(uint256 _rwaId, string calldata _templateType) 
        external onlyOwner returns (bool) {
        ComplianceTemplate storage template = templates[_templateType];
        require(template.approved, "Template not approved");
        
        // Simplified compliance check - in production, integrate with KYC/AML providers
        bool compliant = true; // Placeholder
        
        assetCompliance[_rwaId] = AssetCompliance({
            rwaId: _rwaId,
            templateType: _templateType,
            kycPassed: template.kycRequired ? true : false,
            amlPassed: template.amlRequired ? true : false,
            compliant: compliant
        });
        
        emit ComplianceChecked(_rwaId, compliant);
        return compliant;
    }
    
    /// @notice Approve asset after compliance
    function approveAsset(uint256 _rwaId) external onlyOwner {
        require(assetCompliance[_rwaId].compliant, "Not compliant");
        emit AssetApproved(_rwaId);
    }
    
    /// @notice Get compliance template
    function getTemplate(string calldata _assetType) 
        external view returns (ComplianceTemplate memory) {
        return templates[_assetType];
    }
    
    /// @notice Get asset compliance status
    function getAssetCompliance(uint256 _rwaId) 
        external view returns (AssetCompliance memory) {
        return assetCompliance[_rwaId];
    }
    
    /// @notice Check if asset is compliant
    function isCompliant(uint256 _rwaId) external view returns (bool) {
        return assetCompliance[_rwaId].compliant;
    }
    
    /// @notice Get all template types
    function getAllTemplates() external view returns (string[] memory) {
        return templateTypes;
    }
}
