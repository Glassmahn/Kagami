// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiDevHub
/// @notice Onboarding + reputation system for builders (repo #70)
interface IKagamiDevHub {
    struct Builder {
        address wallet;
        string username;
        uint256 reputation;
        uint256 contributions;
        bool verified;
        uint256 joinedAt;
    }
    
    struct Contribution {
        uint256 id;
        address builder;
        string repoName;
        string description;
        uint256 reward;
        bool validated;
    }
    
    event BuilderRegistered(address indexed wallet, string username);
    event ContributionSubmitted(uint256 indexed contributionId, address indexed builder);
    event BuilderVerified(address indexed wallet);
    event RewardClaimed(uint256 indexed contributionId, address indexed builder, uint256 reward);
    
    /// @notice Register as builder
    function registerBuilder(string calldata _username) external;
    
    /// @notice Submit contribution
    function submitContribution(
        string calldata _repoName,
        string calldata _description
    ) external returns (uint256);
    
    /// @notice Validate contribution (admin only)
    function validateContribution(uint256 _contributionId, uint256 _reward) external;
    
    /// @notice Claim reward for validated contribution
    function claimReward(uint256 _contributionId) external;
    
    /// @notice Verify builder
    function verifyBuilder(address _builder) external;
    
    /// @notice Get builder info
    function getBuilder(address _wallet) external view returns (Builder memory);
    
    /// @notice Get builder contributions
    function getBuilderContributions(address _builder) 
        external view returns (uint256[] memory);
    
    /// @notice Check if builder is verified
    function isVerifiedBuilder(address _builder) external view returns (bool);
}
