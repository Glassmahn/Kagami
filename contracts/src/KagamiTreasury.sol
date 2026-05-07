// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title KagamiTreasury
/// @notice Auto-distributed revenue vault (repo #8)
contract KagamiTreasury is Ownable {
    struct RevenueStream {
        address token;
        uint256 totalReceived;
        uint256 totalDistributed;
        bool active;
    }
    
    mapping(uint256 => RevenueStream) public revenueStreams;
    uint256 public streamCount;
    
    event RevenueReceived(uint256 indexed streamId, address indexed from, uint256 amount);
    event RevenueDistributed(uint256 indexed streamId, address indexed to, uint256 amount);
    event StreamCreated(uint256 indexed streamId, address token);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Create a new revenue stream for a reflection
    function createRevenueStream(address _token) external returns (uint256) {
        streamCount++;
        revenueStreams[streamCount] = RevenueStream({
            token: _token,
            totalReceived: 0,
            totalDistributed: 0,
            active: true
        });
        
        emit StreamCreated(streamCount, _token);
        return streamCount;
    }
    
    /// @notice Receive revenue into a stream
    function receiveRevenue(uint256 _streamId) external payable {
        require(revenueStreams[_streamId].active, "Stream not active");
        revenueStreams[_streamId].totalReceived += msg.value;
        emit RevenueReceived(_streamId, msg.sender, msg.value);
    }
    
    /// @notice Distribute revenue to creator
    function distributeToCreator(uint256 _streamId, address _creator, uint256 _amount) 
        external onlyOwner {
        require(revenueStreams[_streamId].active, "Stream not active");
        require(revenueStreams[_streamId].totalReceived >= _amount, "Insufficient funds");
        
        revenueStreams[_streamId].totalDistributed += _amount;
        payable(_creator).transfer(_amount);
        
        emit RevenueDistributed(_streamId, _creator, _amount);
    }
    
    /// @notice Get stream details
    function getStream(uint256 _streamId) external view returns (
        address token,
        uint256 totalReceived,
        uint256 totalDistributed,
        bool active
    ) {
        RevenueStream storage s = revenueStreams[_streamId];
        return (s.token, s.totalReceived, s.totalDistributed, s.active);
    }
}
