// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiV2Blueprint
/// @notice Next-gen reflection designs (repo #99)
interface IKagamiV2Blueprint {
    struct Blueprint {
        uint256 id;
        string reflectionType;
        string designSpecHash; // IPFS hash
        bool approved;
        uint256 proposedAt;
    }
    
    event BlueprintProposed(uint256 indexed blueprintId, string reflectionType);
    event BlueprintApproved(uint256 indexed blueprintId);
    event BlueprintImplemented(uint256 indexed blueprintId, uint256 reflectionId);
    
    /// @notice Propose V2 blueprint
    function proposeBlueprint(
        string calldata _reflectionType,
        string calldata _designSpecHash
    ) external returns (uint256);
    
    /// @notice Approve blueprint (governance)
    function approveBlueprint(uint256 _blueprintId) external;
    
    /// @notice Implement approved blueprint
    function implementBlueprint(uint256 _blueprintId) external returns (uint256 reflectionId);
    
    /// @notice Get blueprint details
    function getBlueprint(uint256 _blueprintId) external view returns (Blueprint memory);
    
    /// @notice Get all approved blueprints
    function getApprovedBlueprints() external view returns (uint256[] memory);
    
    /// @notice Check if blueprint is implemented
    function isImplemented(uint256 _blueprintId) external view returns (bool);
}
