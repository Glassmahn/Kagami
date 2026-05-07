// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiCrossChain
/// @notice LayerZero bridges for incoming ideas (repo #55)
interface IKagamiCrossChain {
    struct BridgeRequest {
        uint256 id;
        uint256 srcChainId;
        uint256 destChainId;
        uint256 reflectionId;
        address sender;
        bool completed;
        uint256 bridgedAt;
    }
    
    event BridgedToKagami(
        uint256 indexed requestId,
        uint256 indexed srcChainId,
        uint256 destChainId,
        uint256 reflectionId
    );
    event BridgeRequested(uint256 indexed requestId, address indexed sender, uint256 srcChainId);
    
    /// @notice Bridge idea from another chain to KAGAMI on Base
    function bridgeIdea(
        uint256 _srcChainId,
        string calldata _metadataURI
    ) external payable returns (uint256 requestId);
    
    /// @notice Complete bridge (called by relayer)
    function completeBridge(uint256 _requestId) external;
    
    /// @notice Get bridge request details
    function getBridgeRequest(uint256 _requestId) external view returns (BridgeRequest memory);
    
    /// @notice Get user's bridge requests
    function getUserBridgeRequests(address _user) external view returns (uint256[] memory);
    
    /// @notice Check if chain is supported
    function isChainSupported(uint256 _chainId) external view returns (bool);
}
