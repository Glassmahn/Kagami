// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiMultisig
/// @notice All admin/treasury multisigs (repo #82)
interface IKagamiMultisig {
    struct Multisig {
        address multisigAddress;
        address[] owners;
        uint256 requiredConfirmations;
        bool active;
    }
    
    event MultisigCreated(address indexed multisig, address[] owners, uint256 required);
    event TransactionSubmitted(uint256 indexed txId, address indexed submitter);
    event TransactionConfirmed(uint256 indexed txId, address indexed owner);
    event TransactionExecuted(uint256 indexed txId);
    
    /// @notice Create new multisig
    function createMultisig(
        address[] calldata _owners,
        uint256 _requiredConfirmations
    ) external returns (address);
    
    /// @notice Submit transaction to multisig
    function submitTransaction(
        address _multisig,
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external returns (uint256);
    
    /// @notice Confirm transaction
    function confirmTransaction(address _multisig, uint256 _txId) external;
    
    /// @notice Execute confirmed transaction
    function executeTransaction(address _multisig, uint256 _txId) external;
    
    /// @notice Get multisig details
    function getMultisig(address _multisig) external view returns (Multisig memory);
    
    /// @notice Check if address is owner
    function isOwner(address _multisig, address _address) external view returns (bool);
}
