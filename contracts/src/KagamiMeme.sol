// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiMeme
/// @notice Official KAGAMI meme token on Base
contract KagamiMeme is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18; // 1 billion
    uint256 public totalMinted;
    bool public mintingEnabled = true;
    
    event MintEnabled(bool enabled);
    event MemeMinted(address indexed to, uint256 amount);
    
    constructor() ERC20("KAGAMI Meme", "KAG") Ownable(msg.sender) {}
    
    /// @notice Mint initial supply (one-time)
    function mintInitialSupply() external onlyOwner {
        require(mintingEnabled, "Minting disabled");
        require(totalMinted == 0, "Already minted");
        
        _mint(msg.sender, MAX_SUPPLY);
        totalMinted = MAX_SUPPLY;
        mintingEnabled = false;
        
        emit MemeMinted(msg.sender, MAX_SUPPLY);
        emit MintEnabled(false);
    }
    
    /// @notice Mint additional tokens (if enabled)
    function mint(address _to, uint256 _amount) external onlyOwner {
        require(mintingEnabled, "Minting disabled");
        require(totalMinted + _amount <= MAX_SUPPLY, "Exceeds max supply");
        
        _mint(_to, _amount);
        totalMinted += _amount;
        
        emit MemeMinted(_to, _amount);
    }
    
    /// @notice Disable minting (one-way)
    function disableMinting() external onlyOwner {
        mintingEnabled = false;
        emit MintEnabled(false);
    }
    
    /// @notice Get remaining mintable supply
    function getRemainingMintable() external view returns (uint256) {
        return mintingEnabled ? MAX_SUPPLY - totalMinted : 0;
    }
}
