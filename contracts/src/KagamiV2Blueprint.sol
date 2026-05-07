// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiV2Blueprint
/// @notice Next-gen reflection designs (repo #99)
contract KagamiV2Blueprint is Ownable {
    struct Blueprint {
        uint256 id;
        string reflectionType;
        string designSpecHash; // IPFS hash
        bool approved;
        uint256 proposedAt;
        uint256 implementedAt;
    }
    
    uint256 public blueprintCount;
    mapping(uint256 => Blueprint) public blueprints;
    mapping(string => uint256[]) public blueprintsByType;
    mapping(uint256 => uint256) public implementedBlueprint;
    
    event BlueprintProposed(uint256 indexed blueprintId, string reflectionType);
    event BlueprintApproved(uint256 indexed blueprintId);
    event BlueprintImplemented(uint256 indexed blueprintId, uint256 reflectionId);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Propose V2 blueprint
    function proposeBlueprint(
        string calldata _reflectionType,
        string calldata _designSpecHash
    ) external onlyOwner returns (uint256) {
        blueprintCount++;
        
        blueprints[blueprintCount] = Blueprint({
            id: blueprintCount,
            reflectionType: _reflectionType,
            designSpecHash: _designSpecHash,
            approved: false,
            proposedAt: block.timestamp,
            implementedAt: 0
        });
        
        blueprintsByType[_reflectionType].push(blueprintCount);
        
        emit BlueprintProposed(blueprintCount, _reflectionType);
        return blueprintCount;
    }
    
    /// @notice Approve blueprint (governance)
    function approveBlueprint(uint256 _blueprintId) external onlyOwner {
        Blueprint storage bp = blueprints[_blueprintId];
        require(bp.id > 0, "Blueprint not found");
        require(!bp.approved, "Already approved");
        
        bp.approved = true;
        emit BlueprintApproved(_blueprintId);
    }
    
    /// @notice Implement approved blueprint
    function implementBlueprint(uint256 _blueprintId) external onlyOwner returns (uint256 reflectionId) {
        Blueprint storage bp = blueprints[_blueprintId];
        require(bp.approved, "Not approved");
        require(bp.implementedAt == 0, "Already implemented");
        
        // In production, this would deploy new reflection with blueprint specs
        reflectionId = bp.id * 1000; // Mock reflection ID
        bp.implementedAt = block.timestamp;
        implementedBlueprint[bp.id] = reflectionId;
        
        emit BlueprintImplemented(_blueprintId, reflectionId);
        return reflectionId;
    }
    
    /// @notice Get blueprint details
    function getBlueprint(uint256 _blueprintId) external view returns (Blueprint memory) {
        return blueprints[_blueprintId];
    }
    
    /// @notice Get all approved blueprints
    function getApprovedBlueprints() external view returns (uint256[] memory) {
        uint256[] memory temp = new uint256[](blueprintCount);
        uint256 count = 0;
        
        for (uint256 i = 1; i <= blueprintCount; i++) {
            if (blueprints[i].approved && blueprints[i].implementedAt == 0) {
                temp[count++] = i;
            }
        }
        
        // Trim array
        uint256[] memory approved = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            approved[i] = temp[i];
        }
        
        return approved;
    }
    
    /// @notice Get blueprints by type
    function getBlueprintsByType(string calldata _type) 
        external view returns (uint256[] memory) {
        return blueprintsByType[_type];
    }
    
    /// @notice Check if blueprint is implemented
    function isImplemented(uint256 _blueprintId) external view returns (bool) {
        return blueprints[_blueprintId].implementedAt > 0;
    }
    
    /// @notice Get total blueprints
    function getTotalBlueprints() external view returns (uint256) {
        return blueprintCount;
    }
}
