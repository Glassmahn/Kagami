// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./ReflectionEngine.sol";
import "./KagamiToken.sol";
import "./SeedFactory.sol";
import "./KagamiTreasury.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiCore
/// @notice Main reflection, shard creation, revenue routing contracts (repo #1)
contract KagamiCore is Ownable {
    ReflectionEngine public immutable reflectionEngine;
    KagamiToken public immutable kagamiToken;
    SeedFactory public immutable seedFactory;
    KagamiTreasury public immutable treasury;
    
    struct KagamiInfo {
        uint256 reflectionId;
        address creator;
        uint256 totalShards;
        uint256 totalRevenue;
        bool active;
    }
    
    mapping(uint256 => KagamiInfo) public kagamis;
    uint256 public kagamiCount;
    
    event KagamiCreated(
        uint256 indexed kagamiId,
        address indexed creator,
        uint256 reflectionId,
        string metadataURI
    );
    
    event RevenueRouted(
        uint256 indexed kagamiId,
        uint256 amount,
        address indexed destination
    );
    
    constructor(
        address _reflectionEngine,
        address _kagamiToken,
        address _seedFactory,
        address _treasury
    ) Ownable(msg.sender) {
        reflectionEngine = ReflectionEngine(_reflectionEngine);
        kagamiToken = KagamiToken(_kagamiToken);
        seedFactory = SeedFactory(_seedFactory);
        treasury = KagamiTreasury(_treasury);
    }
    
    /// @notice Create a full KAGAMI from an idea (permissionless)
    function createKagami(string calldata _metadataURI) external returns (uint256) {
        uint256 reflectionId = seedFactory.seedIdea(_metadataURI);
        
        kagamiCount++;
        kagamis[kagamiCount] = KagamiInfo({
            reflectionId: reflectionId,
            creator: msg.sender,
            totalShards: 0,
            totalRevenue: 0,
            active: true
        });
        
        emit KagamiCreated(kagamiCount, msg.sender, reflectionId, _metadataURI);
        
        return kagamiCount;
    }
    
    /// @notice Get Kagami info
    function getKagami(uint256 _kagamiId) external view returns (KagamiInfo memory) {
        return kagamis[_kagamiId];
    }
}
