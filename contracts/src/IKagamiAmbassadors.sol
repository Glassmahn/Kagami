// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiAmbassadors
/// @notice Onchain ambassador tracking (repo #94)
interface IKagamiAmbassadors {
    struct Ambassador {
        address wallet;
        string region;
        uint256 reflectionsPromoted;
        uint256 rewardsEarned;
        bool active;
        uint256 joinedAt;
    }
    
    event AmbassadorRegistered(address indexed wallet, string region);
    event ReflectionPromoted(uint256 indexed reflectionId, address indexed ambassador);
    event RewardClaimed(address indexed ambassador, uint256 amount);
    
    /// @notice Register as ambassador
    function registerAmbassador(string calldata _region) external;
    
    /// @notice Promote a reflection
    function promoteReflection(uint256 _reflectionId) external;
    
    /// @notice Claim rewards
    function claimReward() external returns (uint256);
    
    /// @notice Get ambassador details
    function getAmbassador(address _wallet) external view returns (Ambassador memory);
    
    /// @notice Get ambassadors by region
    function getAmbassadorsByRegion(string calldata _region) 
        external view returns (address[] memory);
    
    /// @notice Check if address is active ambassador
    function isActiveAmbassador(address _wallet) external view returns (bool);
}
