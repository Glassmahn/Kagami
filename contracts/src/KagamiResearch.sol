// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiResearch
/// @notice Mechanism design papers (repo #97)
contract KagamiResearch is Ownable {
    struct Paper {
        uint256 id;
        string title;
        string ipfsHash;
        address author;
        uint256 publishedAt;
        bool peerReviewed;
    }
    
    uint256 public paperCount;
    mapping(uint256 => Paper) public papers;
    mapping(address => uint256[]) public authorPapers;
    
    event PaperPublished(uint256 indexed paperId, address indexed author, string title);
    event PeerReviewCompleted(uint256 indexed paperId, bool approved);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Publish research paper
    function publishPaper(
        string calldata _title,
        string calldata _ipfsHash
    ) external returns (uint256) {
        paperCount++;
        
        papers[paperCount] = Paper({
            id: paperCount,
            title: _title,
            ipfsHash: _ipfsHash,
            author: msg.sender,
            publishedAt: block.timestamp,
            peerReviewed: false
        });
        
        authorPapers[msg.sender].push(paperCount);
        
        emit PaperPublished(paperCount, msg.sender, _title);
        return paperCount;
    }
    
    /// @notice Peer review (admin only)
    function peerReview(uint256 _paperId, bool _approved) external onlyOwner {
        Paper storage paper = papers[_paperId];
        require(paper.id > 0, "Paper not found");
        require(!paper.peerReviewed, "Already reviewed");
        
        paper.peerReviewed = true;
        emit PeerReviewCompleted(_paperId, _approved);
    }
    
    /// @notice Get paper details
    function getPaper(uint256 _paperId) external view returns (Paper memory) {
        return papers[_paperId];
    }
    
    /// @notice Get all papers by author
    function getPapersByAuthor(address _author) external view returns (uint256[] memory) {
        return authorPapers[_author];
    }
    
    /// @notice Get all published papers
    function getAllPapers() external view returns (uint256[] memory) {
        uint256[] memory all = new uint256[](paperCount);
        for (uint256 i = 0; i < paperCount; i++) {
            all[i] = i + 1;
        }
        return all;
    }
    
    /// @notice Check if paper is peer-reviewed
    function isPeerReviewed(uint256 _paperId) external view returns (bool) {
        return papers[_paperId].peerReviewed;
    }
}
