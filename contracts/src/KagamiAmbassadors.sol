// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiAmbassadors
/// @notice Onchain ambassador tracking (repo #94)
contract KagamiAmbassadors is Ownable {
    struct Ambassador {
        address wallet;
        string region;
        uint256 reflectionsPromoted;
        uint256 rewardsEarned;
        bool active;
        uint256 joinedAt;
    }
    
    uint256 public ambassadorCount;
    mapping(address => Ambassador) public ambassadors;
    mapping(string => address[]) public regionAmbassadors;
    
    event AmbassadorRegistered(address indexed wallet, string region);
    event ReflectionPromoted(uint256 indexed reflectionId, address indexed ambassador);
    event RewardClaimed(address indexed ambassador, uint256 amount);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Register as ambassador
    function registerAmbassador(string calldata _region) external {
        require(ambassadors[msg.sender].joinedAt == 0, "Already registered");
        
        ambassadors[msg.sender] = Ambassador({
            wallet: msg.sender,
            region: _region,
            reflectionsPromoted: 0,
            rewardsEarned: 0,
            active: true,
            joinedAt: block.timestamp
        });
        
        regionAmbassadors[_region].push(msg.sender);
        ambassadorCount++;
        
        emit AmbassadorRegistered(msg.sender, _region);
    }
    
    /// @notice Promote a reflection
    function promoteReflection(uint256 _reflectionId) external {
        Ambassador storage amb = ambassadors[msg.sender];
        require(amb.active, "Not active ambassador");
        
        amb.reflectionsPromoted++;
        emit ReflectionPromoted(_reflectionId, msg.sender);
    }
    
    /// @notice Claim rewards
    function claimReward() external returns (uint256) {
        Ambassador storage amb = ambassadors[msg.sender];
        require(amb.active, "Not active ambassador");
        
        uint256 reward = amb.reflectionsPromoted * 10**18; // 1 token per promotion
        amb.rewardsEarned += reward;
        
        payable(msg.sender).transfer(reward);
        emit RewardClaimed(msg.sender, reward);
        
        return reward;
    }
    
    /// @notice Get ambassador details
    function getAmbassador(address _wallet) 
        external view returns (Ambassador memory) {
        return ambassadors[_wallet];
    }
    
    /// @notice Get ambassadors by region
    function getAmbassadorsByRegion(string calldata _region) 
        external view returns (address[] memory) {
        return regionAmbassadors[_region];
    }
    
    /// @notice Check if address is active ambassador
    function isActiveAmbassador(address _wallet) external view returns (bool) {
        return ambassadors[_wallet].active;
    }
}
