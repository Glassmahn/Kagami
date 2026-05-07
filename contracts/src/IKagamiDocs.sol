// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiDocs
/// @notice Beautiful docs + interactive playground (repo #66)
interface IKagamiDocs {
    struct DocPage {
        string slug;
        string title;
        string contentHash; // IPFS hash
        uint256 lastUpdated;
        bool published;
    }
    
    event DocCreated(string indexed slug, string title);
    event DocUpdated(string indexed slug, uint256 timestamp);
    event PlaygroundExampleAdded(string name, string codeHash);
    
    /// @notice Create documentation page
    function createDoc(string calldata _slug, string calldata _title, string calldata _contentHash) 
        external returns (bool);
    
    /// @notice Update documentation
    function updateDoc(string calldata _slug, string calldata _newContentHash) external;
    
    /// @notice Add interactive playground example
    function addPlaygroundExample(string calldata _name, string calldata _codeHash) external;
    
    /// @notice Get documentation page
    function getDoc(string calldata _slug) external view returns (DocPage memory);
    
    /// @notice Get all published docs
    function getPublishedDocs() external view returns (string[] memory slugs);
    
    /// @notice Check if doc exists
    function docExists(string calldata _slug) external view returns (bool);
}
