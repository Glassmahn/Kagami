// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiCoinbaseSmartWallet
/// @notice Official paymaster + wallet support (repo #49)
interface IKagamiCoinbaseSmartWallet {
    struct SmartWallet {
        address owner;
        address walletAddress;
        bool deployed;
        uint256 nonce;
    }
    
    event WalletDeployed(address indexed owner, address indexed wallet, uint256 nonce);
    event PaymasterUsed(address indexed wallet, uint256 gasCost, address payer);
    event TransactionExecuted(address indexed wallet, bytes32 txHash);
    
    /// @notice Deploy smart wallet for user (gasless via paymaster)
    function deployWallet() external returns (address wallet);
    
    /// @notice Execute transaction through paymaster (gasless)
    function executeGasless(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external;
    
    /// @notice Get smart wallet for user
    function getWallet(address _owner) external view returns (SmartWallet memory);
    
    /// @notice Check if wallet is deployed
    function isWalletDeployed(address _owner) external view returns (bool);
    
    /// @notice Get paymaster balance
    function getPaymasterBalance() external view returns (uint256);
    
    /// @notice Sponsor gas for user (admin only)
    function sponsorGas(address _user) external;
}
