// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiStarter
/// @notice Base starter contract for all KAGAMI reflection repos
contract KagamiStarter is Ownable {
    string public name;
    string public reflectionType;

    event ReflectionCreated(address indexed creator, string name, uint256 timestamp);

    constructor(string memory _name, string memory _reflectionType) Ownable(msg.sender) {
        name = _name;
        reflectionType = _reflectionType;
    }

    function createReflection(string memory _metadataURI) external {
        emit ReflectionCreated(msg.sender, name, block.timestamp);
    }

    function updateReflectionType(string memory _newType) external onlyOwner {
        reflectionType = _newType;
    }
}
