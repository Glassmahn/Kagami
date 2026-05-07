// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiRelayer
/// @notice Gasless everything (repo #77)
contract KagamiRelayer is Ownable {
    struct GaslessTransaction {
        uint256 id;
        address user;
        address target;
        uint256 value;
        bytes data;
        uint256 gasLimit;
        bool executed;
        bool reverted;
    }
    
    uint256 public txCount;
    mapping(uint256 => GaslessTransaction) public transactions;
    mapping(address => uint256[]) public userTransactions;
    
    uint256 public relayerFee = 0; // Accept tips, but base is free
    address public feeCollector;
    
    event TransactionRelayed(uint256 indexed txId, address indexed user, address target);
    event TransactionExecuted(uint256 indexed txId, bool success);
    event RelayerFeeUpdated(uint256 newFee);
    event FeeCollectorUpdated(address indexed newCollector);
    
    constructor() Ownable(msg.sender) {
        feeCollector = msg.sender;
    }
    
    /// @notice Relay transaction (gasless for user)
    function relayTransaction(
        address _target,
        uint256 _value,
        bytes calldata _data,
        uint256 _gasLimit
    ) external returns (uint256) {
        txCount++;
        
        transactions[txCount] = GaslessTransaction({
            id: txCount,
            user: msg.sender,
            target: _target,
            value: _value,
            data: _data,
            gasLimit: _gasLimit,
            executed: false,
            reverted: false
        });
        
        userTransactions[msg.sender].push(txCount);
        
        emit TransactionRelayed(txCount, msg.sender, _target);
        return txCount;
    }
    
    /// @notice Execute relayed transaction (called by relayer)
    function executeTransaction(uint256 _txId) external onlyOwner {
        GaslessTransaction storage txn = transactions[_txId];
        require(!txn.executed, "Already executed");
        
        txn.executed = true;
        
        (bool success, ) = txn.target.call{value: txn.value, gas: txn.gasLimit}(txn.data);
        txn.reverted = !success;
        
        emit TransactionExecuted(_txId, success);
    }
    
    /// @notice Update relayer fee
    function setRelayerFee(uint256 _newFee) external onlyOwner {
        relayerFee = _newFee;
        emit RelayerFeeUpdated(_newFee);
    }
    
    /// @notice Update fee collector
    function setFeeCollector(address _newCollector) external onlyOwner {
        feeCollector = _newCollector;
        emit FeeCollectorUpdated(_newCollector);
    }
    
    /// @notice Get user's transactions
    function getUserTransactions(address _user) external view returns (uint256[] memory) {
        return userTransactions[_user];
    }
}
