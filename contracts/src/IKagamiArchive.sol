// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiArchive
/// @notice Historical kagami snapshots (repo #98)
interface IKagamiArchive {
    struct Snapshot {
        uint256 id;
        uint256 reflectionId;
        uint256 blockNumber;
        string stateHash; // IPFS hash of full state
        uint256 timestamp;
    }
    
    event SnapshotTaken(uint256 indexed snapshotId, uint256 indexed reflectionId, uint256 blockNumber);
    event SnapshotRestored(uint256 indexed snapshotId, uint256 reflectionId);
    
    /// @notice Take snapshot of reflection state
    function takeSnapshot(uint256 _reflectionId, string calldata _stateHash) 
        external returns (uint256);
    
    /// @notice Restore reflection from snapshot
    function restoreSnapshot(uint256 _snapshotId) external;
    
    /// @notice Get snapshot details
    function getSnapshot(uint256 _snapshotId) external view returns (Snapshot memory);
    
    /// @notice Get all snapshots for reflection
    function getReflectionSnapshots(uint256 _reflectionId) 
        external view returns (uint256[] memory);
    
    /// @notice Get latest snapshot for reflection
    function getLatestSnapshot(uint256 _reflectionId) 
        external view returns (Snapshot memory);
    
    /// @notice Check if snapshot exists
    function snapshotExists(uint256 _snapshotId) external view returns (bool);
}
