// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiResearch
/// @notice Mechanism design papers (repo #97)
interface IKagamiResearch {
    struct Paper {
        uint256 id;
        string title;
        string ipfsHash;
        address author;
        uint256 publishedAt;
        bool peerReviewed;
    }
    
    event PaperPublished(uint256 indexed paperId, address indexed author, string title);
    event PeerReviewCompleted(uint256 indexed paperId, bool approved);
    
    /// @notice Publish research paper
    function publishPaper(
        string calldata _title,
        string calldata _ipfsHash
    ) external returns (uint256);
    
    /// @notice Peer review (admin only)
    function peerReview(uint256 _paperId, bool _approved) external;
    
    /// @notice Get paper details
    function getPaper(uint256 _paperId) external view returns (Paper memory);
    
    /// @notice Get all papers by author
    function getPapersByAuthor(address _author) external view returns (uint256[] memory);
    
    /// @notice Get all published papers
    function getAllPapers() external view returns (uint256[] memory);
    
    /// @notice Check if paper is peer-reviewed
    function isPeerReviewed(uint256 _paperId) external view returns (bool);
}
