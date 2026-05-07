// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./SeedFactory.sol";
import "./IOracleAdapter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AgentSeeder
/// @notice AI that detects trends and auto-launches kagamis (repo #19)
contract AgentSeeder is Ownable {
    SeedFactory public seedFactory;
    IOracleAdapter public oracle;
    
    struct TrendingIdea {
        string metadataURI;
        uint256 culturalScore;
        uint256 timestamp;
        bool seeded;
        uint256 reflectionId;
    }
    
    uint256 public ideaCount;
    mapping(uint256 => TrendingIdea) public trendingIdeas;
    uint256 public minScoreThreshold = 70; // minimum cultural score to auto-seed
    
    event TrendDetected(uint256 indexed ideaId, string metadataURI, uint256 score);
    event AutoSeeded(uint256 indexed ideaId, uint256 reflectionId);
    
    constructor(address _seedFactory, address _oracle) Ownable(msg.sender) {
        seedFactory = SeedFactory(_seedFactory);
        oracle = IOracleAdapter(_oracle);
    }
    
    /// @notice Detect trend and auto-seed if score is high enough
    function detectAndSeed(string calldata _metadataURI, bytes32 _signalId) 
        external returns (uint256 ideaId, uint256 reflectionId) {
        (uint256 culturalScore, ) = oracle.getCulturalSignal(_signalId);
        
        ideaCount++;
        trendingIdeas[ideaCount] = TrendingIdea({
            metadataURI: _metadataURI,
            culturalScore: culturalScore,
            timestamp: block.timestamp,
            seeded: false,
            reflectionId: 0
        });
        
        emit TrendDetected(ideaCount, _metadataURI, culturalScore);
        
        if (culturalScore >= minScoreThreshold) {
            reflectionId = seedFactory.seedIdea(_metadataURI);
            trendingIdeas[ideaCount].seeded = true;
            trendingIdeas[ideaCount].reflectionId = reflectionId;
            
            emit AutoSeeded(ideaCount, reflectionId);
        }
        
        return (ideaCount, reflectionId);
    }
    
    /// @notice Set minimum score threshold for auto-seeding
    function setMinScoreThreshold(uint256 _threshold) external onlyOwner {
        minScoreThreshold = _threshold;
    }
    
    /// @notice Get trending idea
    function getTrendingIdea(uint256 _ideaId) external view returns (TrendingIdea memory) {
        return trendingIdeas[_ideaId];
    }
}
