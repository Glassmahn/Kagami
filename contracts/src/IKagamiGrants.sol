// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiGrants
/// @notice Ecosystem fund contracts (repo #93)
interface IKagamiGrants {
    struct Grant {
        uint256 id;
        address recipient;
        string purpose;
        uint256 amount;
        uint256 vestedAt;
        bool approved;
        bool claimed;
    }
    
    event GrantProposed(uint256 indexed grantId, address indexed recipient, uint256 amount);
    event GrantApproved(uint256 indexed grantId);
    event GrantClaimed(uint256 indexed grantId, address indexed recipient, uint256 amount);
    
    /// @notice Propose a grant
    function proposeGrant(
        address _recipient,
        string calldata _purpose,
        uint256 _amount
    ) external returns (uint256);
    
    /// @notice Approve grant (governance)
    function approveGrant(uint256 _grantId) external;
    
    /// @notice Claim approved grant
    function claimGrant(uint256 _grantId) external;
    
    /// @notice Get grant details
    function getGrant(uint256 _grantId) external view returns (Grant memory);
    
    /// @notice Get grants by recipient
    function getRecipientGrants(address _recipient) external view returns (uint256[] memory);
    
    /// @notice Check if grant is claimable
    function isClaimable(uint256 _grantId) external view returns (bool);
}
