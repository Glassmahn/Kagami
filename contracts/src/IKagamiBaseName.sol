// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiBaseName
/// @notice .base.eth profiles for every kagami (repo #52)
interface IKagamiBaseName {
    struct BaseName {
        uint256 kagamiId;
        string name; // "something.base.eth"
        address owner;
        bool active;
        uint256 registeredAt;
    }
    
    event NameRegistered(uint256 indexed kagamiId, string name, address indexed owner);
    event NameUpdated(uint256 indexed kagamiId, string newName);
    event NameRevoked(uint256 indexed kagamiId);
    
    /// @notice Register .base.eth name for kagami
    function registerName(uint256 _kagamiId, string calldata _name) external returns (bool);
    
    /// @notice Update existing name
    function updateName(uint256 _kagamiId, string calldata _newName) external;
    
    /// @notice Revoke/delete name
    function revokeName(uint256 _kagamiId) external;
    
    /// @notice Get name for kagami
    function getName(uint256 _kagamiId) external view returns (BaseName memory);
    
    /// @notice Resolve name to kagami
    function resolveName(string calldata _name) external view returns (uint256 kagamiId);
    
    /// @notice Check if name is available
    function isNameAvailable(string calldata _name) external view returns (bool);
}
