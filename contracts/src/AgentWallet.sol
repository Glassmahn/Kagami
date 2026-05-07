// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IAgentSDK.sol";

/// @title AgentWallet
/// @notice Smart wallet factory for agent-owned kagamis (repo #17)
contract AgentWallet is Ownable {
    IAgentSDK public agentSDK;
    
    struct Wallet {
        address owner;
        uint256 agentId;
        bool active;
        uint256 kagamiCount;
    }
    
    mapping(address => Wallet) public wallets;
    mapping(uint256 => address) public agentToWallet;
    
    event WalletCreated(address indexed wallet, address indexed owner, uint256 agentId);
    event KagamiAdded(uint256 indexed agentId, uint256 kagamiId);
    
    constructor(address _agentSDK) Ownable(msg.sender) {
        agentSDK = IAgentSDK(_agentSDK);
    }
    
    /// @notice Create smart wallet for an agent
    function createWallet(uint256 _agentId) external returns (address) {
        require(agentToWallet[_agentId] == address(0), "Wallet exists");
        
        AgentWallet wallet = new AgentWallet(address(agentSDK));
        wallets[address(wallet)] = Wallet({
            owner: msg.sender,
            agentId: _agentId,
            active: true,
            kagamiCount: 0
        });
        
        agentToWallet[_agentId] = address(wallet);
        
        emit WalletCreated(address(wallet), msg.sender, _agentId);
        return address(wallet);
    }
    
    /// @notice Add kagami to agent's wallet
    function addKagami(uint256 _kagamiId) external {
        Wallet storage wallet = wallets[msg.sender];
        require(wallet.active, "Wallet not active");
        
        wallet.kagamiCount++;
        emit KagamiAdded(wallet.agentId, _kagamiId);
    }
    
    /// @notice Execute transaction (only owner)
    function execute(address _to, uint256 _value, bytes calldata _data) external {
        Wallet storage wallet = wallets[msg.sender];
        require(wallet.owner == msg.sender, "Not owner");
        
        (bool success, ) = _to.call{value: _value}(_data);
        require(success, "Execution failed");
    }
    
    /// @notice Get wallet info
    function getWallet(address _wallet) external view returns (Wallet memory) {
        return wallets[_wallet];
    }
}
