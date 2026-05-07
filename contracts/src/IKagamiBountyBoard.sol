// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiBountyBoard
/// @notice Onchain bounties for contributors (repo #69)
interface IKagamiBountyBoard {
    struct Bounty {
        uint256 id;
        address creator;
        string title;
        string description;
        uint256 reward; // in wei
        bool active;
        bool completed;
        address assignedTo;
    }
    
    event BountyCreated(uint256 indexed bountyId, address indexed creator, string title);
    event BountyClaimed(uint256 indexed bountyId, address indexed claimer);
    event BountyCompleted(uint256 indexed bountyId, address indexed submitter);
    event RewardClaimed(uint256 indexed bountyId, address indexed claimer, uint256 reward);
    
    /// @notice Create a bounty
    function createBounty(
        string calldata _title,
        string calldata _description,
        uint256 _reward
    ) external payable returns (uint256) {
        require(msg.value >= _reward, "Insufficient reward");
        // Implementation
    }
    
    /// @notice Claim a bounty
    function claimBounty(uint256 _bountyId) external;
    
    /// @notice Submit work for bounty
    function submitWork(uint256 _bountyId, string calldata _submissionURI) external;
    
    /// @notice Approve and pay bounty
    function approveBounty(uint256 _bountyId) external;
    
    /// @notice Get bounty details
    function getBounty(uint256 _bountyId) external view returns (Bounty memory);
    
    /// @notice Get active bounties
    function getActiveBounties() external view returns (uint256[] memory);
}
