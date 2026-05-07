// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiChangelog
/// @notice Every release documented (repo #96)
interface IKagamiChangelog {
    struct Release {
        uint256 id;
        string version; // "v0.1.0"
        string description;
        uint256 releasedAt;
        bool major;
    }
    
    event ReleaseAdded(uint256 indexed releaseId, string version, bool major);
    event ReleaseUpdated(uint256 indexed releaseId, string newDescription);
    
    /// @notice Add a new release
    function addRelease(
        string calldata _version,
        string calldata _description,
        bool _major
    ) external returns (uint256);
    
    /// @notice Update release description
    function updateRelease(uint256 _releaseId, string calldata _newDescription) external;
    
    /// @notice Get release details
    function getRelease(uint256 _releaseId) external view returns (Release memory);
    
    /// @notice Get all releases
    function getAllReleases() external view returns (uint256[] memory);
    
    /// @notice Get latest version
    function getLatestVersion() external view returns (string memory);
    
    /// @notice Check if version is major
    function isMajorVersion(uint256 _releaseId) external view returns (bool);
}
