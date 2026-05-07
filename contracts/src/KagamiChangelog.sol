// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiChangelog
/// @notice Every release documented (repo #96)
contract KagamiChangelog is Ownable {
    struct Release {
        uint256 id;
        string version; // "v0.1.0"
        string description;
        uint256 releasedAt;
        bool major;
    }
    
    uint256 public releaseCount;
    mapping(uint256 => Release) public releases;
    mapping(string => uint256) public versionToId;
    
    event ReleaseAdded(uint256 indexed releaseId, string version, bool major);
    event ReleaseUpdated(uint256 indexed releaseId, string newDescription);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Add a new release
    function addRelease(
        string calldata _version,
        string calldata _description,
        bool _major
    ) external onlyOwner returns (uint256) {
        releaseCount++;
        
        releases[releaseCount] = Release({
            id: releaseCount,
            version: _version,
            description: _description,
            releasedAt: block.timestamp,
            major: _major
        });
        
        versionToId[_version] = releaseCount;
        
        emit ReleaseAdded(releaseCount, _version, _major);
        return releaseCount;
    }
    
    /// @notice Update release description
    function updateRelease(uint256 _releaseId, string calldata _newDescription) external onlyOwner {
        Release storage release = releases[_releaseId];
        require(release.id > 0, "Release not found");
        
        release.description = _newDescription;
        emit ReleaseUpdated(_releaseId, _newDescription);
    }
    
    /// @notice Get release details
    function getRelease(uint256 _releaseId) external view returns (Release memory) {
        return releases[_releaseId];
    }
    
    /// @notice Get all releases
    function getAllReleases() external view returns (uint256[] memory) {
        uint256[] memory all = new uint256[](releaseCount);
        for (uint256 i = 0; i < releaseCount; i++) {
            all[i] = i + 1;
        }
        return all;
    }
    
    /// @notice Get latest version
    function getLatestVersion() external view returns (string memory) {
        require(releaseCount > 0, "No releases");
        return releases[releaseCount].version;
    }
    
    /// @notice Check if version is major
    function isMajorVersion(uint256 _releaseId) external view returns (bool) {
        return releases[_releaseId].major;
    }
    
    /// @notice Get release by version string
    function getReleaseByVersion(string calldata _version) external view returns (Release memory) {
        uint256 id = versionToId[_version];
        require(id > 0, "Version not found");
        return releases[id];
    }
}
