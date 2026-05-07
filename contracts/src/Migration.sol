// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IReflectionEngine.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Migration
/// @notice Seamless V1 → V2 paths (repo #14)
contract Migration is Ownable {
    IReflectionEngine public v1Engine;
    IReflectionEngine public v2Engine;
    
    struct MigrationRecord {
        uint256 v1ReflectionId;
        uint256 v2ReflectionId;
        address owner;
        uint256 migratedAt;
        bool completed;
    }
    
    mapping(uint256 => MigrationRecord) public migrations;
    uint256 public migrationCount;
    
    event MigrationStarted(
        uint256 indexed migrationId,
        uint256 indexed v1Id,
        address indexed owner
    );
    event MigrationCompleted(uint256 indexed migrationId, uint256 v2ReflectionId);
    
    constructor(address _v1Engine, address _v2Engine) Ownable(msg.sender) {
        v1Engine = IReflectionEngine(_v1Engine);
        v2Engine = IReflectionEngine(_v2Engine);
    }
    
    /// @notice Start migration of V1 reflection to V2
    function startMigration(uint256 _v1ReflectionId, string calldata _newMetadataURI) 
        external returns (uint256) {
        (address creator, , , , ) = v1Engine.getReflection(_v1ReflectionId);
        require(creator == msg.sender, "Not the creator");
        
        migrationCount++;
        uint256 v2Id = v2Engine.createReflection(_newMetadataURI);
        
        migrations[migrationCount] = MigrationRecord({
            v1ReflectionId: _v1ReflectionId,
            v2ReflectionId: v2Id,
            owner: msg.sender,
            migratedAt: block.timestamp,
            completed: false
        });
        
        emit MigrationStarted(migrationCount, _v1ReflectionId, msg.sender);
        
        return migrationCount;
    }
    
    /// @notice Complete migration (admin trigger after validation)
    function completeMigration(uint256 _migrationId) external onlyOwner {
        MigrationRecord storage record = migrations[_migrationId];
        require(!record.completed, "Already completed");
        
        record.completed = true;
        
        emit MigrationCompleted(_migrationId, record.v2ReflectionId);
    }
    
    /// @notice Get migration details
    function getMigration(uint256 _migrationId) external view returns (MigrationRecord memory) {
        return migrations[_migrationId];
    }
}
