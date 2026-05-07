// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiArchive
/// @notice Historical kagami snapshots (repo #98)
contract KagamiArchive is Ownable {
    struct Snapshot {
        uint256 id;
        uint256 reflectionId;
        uint256 blockNumber;
        string stateHash; // IPFS hash of full state
        uint256 timestamp;
        bool restored;
    }
    
    uint256 public snapshotCount;
    mapping(uint256 => Snapshot) public snapshots;
    mapping(uint256 => uint256[]) public reflectionSnapshots;
    mapping(uint256 => uint256) public latestSnapshotId;
    
    event SnapshotTaken(uint256 indexed snapshotId, uint256 indexed reflectionId, uint256 blockNumber);
    event SnapshotRestored(uint256 indexed snapshotId, uint256 reflectionId);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Take snapshot of reflection state
    function takeSnapshot(
        uint256 _reflectionId, 
        string calldata _stateHash
    ) external onlyOwner returns (uint256) {
        snapshotCount++;
        
        snapshots[snapshotCount] = Snapshot({
            id: snapshotCount,
            reflectionId: _reflectionId,
            blockNumber: block.number,
            stateHash: _stateHash,
            timestamp: block.timestamp,
            restored: false
        });
        
        reflectionSnapshots[_reflectionId].push(snapshotCount);
        latestSnapshotId[_reflectionId] = snapshotCount;
        
        emit SnapshotTaken(snapshotCount, _reflectionId, block.number);
        return snapshotCount;
    }
    
    /// @notice Restore reflection from snapshot
    function restoreSnapshot(uint256 _snapshotId) external onlyOwner {
        Snapshot storage snapshot = snapshots[_snapshotId];
        require(snapshot.id > 0, "Snapshot not found");
        require(!snapshot.restored, "Already restored");
        
        snapshot.restored = true;
        emit SnapshotRestored(_snapshotId, snapshot.reflectionId);
    }
    
    /// @notice Get snapshot details
    function getSnapshot(uint256 _snapshotId) external view returns (Snapshot memory) {
        return snapshots[_snapshotId];
    }
    
    /// @notice Get all snapshots for reflection
    function getReflectionSnapshots(uint256 _reflectionId) 
        external view returns (uint256[] memory) {
        return reflectionSnapshots[_reflectionId];
    }
    
    /// @notice Get latest snapshot for reflection
    function getLatestSnapshot(uint256 _reflectionId) 
        external view returns (Snapshot memory) {
        uint256 latestId = latestSnapshotId[_reflectionId];
        return snapshots[latestId];
    }
    
    /// @notice Check if snapshot exists
    function snapshotExists(uint256 _snapshotId) external view returns (bool) {
        return snapshots[_snapshotId].id > 0;
    }
    
    /// @notice Get total snapshots
    function getTotalSnapshots() external view returns (uint256) {
        return snapshotCount;
    }
}
