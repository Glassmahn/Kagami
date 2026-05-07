// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./IReflectionEngine.sol";
import "./ReflectionEngine.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title SeedFactory
/// @notice Permissionless idea-to-kagami launcher (repo #2)
contract SeedFactory is Ownable {
    ReflectionEngine public reflectionEngine;
    
    event IdeaSeeded(
        address indexed creator,
        uint256 indexed reflectionId,
        string ideaMetadataURI,
        uint256 timestamp
    );
    
    constructor(address _reflectionEngine) Ownable(msg.sender) {
        reflectionEngine = ReflectionEngine(_reflectionEngine);
    }
    
    /// @notice Permissionless: anyone can drop an idea to create a kagami
    function seedIdea(string calldata _ideaMetadataURI) external returns (uint256) {
        uint256 reflectionId = reflectionEngine.createReflection(_ideaMetadataURI);
        emit IdeaSeeded(msg.sender, reflectionId, _ideaMetadataURI, block.timestamp);
        return reflectionId;
    }
    
    /// @notice Admin: update reflection engine
    function setReflectionEngine(address _newEngine) external onlyOwner {
        reflectionEngine = ReflectionEngine(_newEngine);
    }
}
