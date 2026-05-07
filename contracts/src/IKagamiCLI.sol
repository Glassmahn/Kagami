// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title IKagamiCLI
/// @notice Terminal "kagami launch" command (repo #64)
interface IKagamiCLI {
    struct LaunchConfig {
        string idea;
        string metadataURI;
        uint256 reflectionType;
        bool enableYield;
        bool enableNFT;
        uint256 initialBudget;
    }
    
    event LaunchInitiated(
        address indexed user,
        uint256 indexed reflectionId,
        string idea
    );
    event CLILaunched(string command, address indexed user, uint256 timestamp);
    
    /// @notice Launch reflection from CLI
    function launchReflection(LaunchConfig calldata _config) external payable returns (uint256);
    
    /// @notice Batch launch multiple reflections
    function batchLaunch(string[] calldata _ideas) external payable returns (uint256[] memory);
    
    /// @notice Get CLI version
    function getCLIVersion() external pure returns (string memory);
    
    /// @notice Check if idea is valid for launch
    function validateIdea(string calldata _idea) external view returns (bool);
    
    /// @notice Get estimated gas for launch
    function estimateLaunchGas(LaunchConfig calldata _config) external view returns (uint256);
}
