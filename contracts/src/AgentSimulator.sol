// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AgentSimulator
/// @notice Local testing sandbox for agent economies (repo #24)
contract AgentSimulator is Ownable {
    struct Simulation {
        uint256 id;
        uint256 agentId;
        uint256 reflectionId;
        uint256 initialFunds;
        uint256 currentFunds;
        uint256 actionsPerformed;
        uint256 profitLoss;
        bool completed;
        uint256 startTime;
        uint256 endTime;
    }
    
    uint256 public simulationCount;
    mapping(uint256 => Simulation) public simulations;
    mapping(uint256 => uint256[]) public agentSimulations;
    
    event SimulationStarted(
        uint256 indexed simulationId,
        uint256 indexed agentId,
        uint256 reflectionId,
        uint256 initialFunds
    );
    event ActionSimulated(uint256 indexed simulationId, string action, uint256 result);
    event SimulationCompleted(uint256 indexed simulationId, uint256 profitLoss);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Start a simulation for an agent
    function startSimulation(
        uint256 _agentId,
        uint256 _reflectionId,
        uint256 _initialFunds
    ) external returns (uint256) {
        simulationCount++;
        
        simulations[simulationCount] = Simulation({
            id: simulationCount,
            agentId: _agentId,
            reflectionId: _reflectionId,
            initialFunds: _initialFunds,
            currentFunds: _initialFunds,
            actionsPerformed: 0,
            profitLoss: 0,
            completed: false,
            startTime: block.timestamp,
            endTime: 0
        });
        
        agentSimulations[_agentId].push(simulationCount);
        
        emit SimulationStarted(simulationCount, _agentId, _reflectionId, _initialFunds);
        return simulationCount;
    }
    
    /// @notice Simulate an action in the sandbox
    function simulateAction(uint256 _simulationId, string calldata _action, int256 _result) 
        external onlyOwner {
        Simulation storage sim = simulations[_simulationId];
        require(!sim.completed, "Simulation completed");
        
        sim.actionsPerformed++;
        sim.currentFunds = uint256(int256(sim.currentFunds) + _result);
        sim.profitLoss = int256(sim.currentFunds) - int256(sim.initialFunds);
        
        emit ActionSimulated(_simulationId, _action, uint256(_result));
    }
    
    /// @notice Complete simulation
    function completeSimulation(uint256 _simulationId) external onlyOwner {
        Simulation storage sim = simulations[_simulationId];
        require(!sim.completed, "Already completed");
        
        sim.completed = true;
        sim.endTime = block.timestamp;
        
        emit SimulationCompleted(_simulationId, sim.profitLoss);
    }
}
