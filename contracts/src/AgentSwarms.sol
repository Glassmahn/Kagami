// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AgentSwarms
/// @notice Multi-agent coordination for complex ideas (repo #23)
contract AgentSwarms is Ownable {
    struct Swarm {
        uint256 id;
        string name;
        uint256 kagamiId;
        address coordinator;
        uint256[] agentIds;
        bool active;
        uint256 createdAt;
    }
    
    struct Task {
        uint256 id;
        uint256 swarmId;
        string description;
        uint256 reward; // in wei
        bool completed;
        address assignedAgent;
    }
    
    uint256 public swarmCount;
    uint256 public taskCount;
    mapping(uint256 => Swarm) public swarms;
    mapping(uint256 => Task) public tasks;
    mapping(uint256 => uint256[]) public swarmTasks;
    
    event SwarmCreated(uint256 indexed swarmId, string name, address coordinator);
    event AgentJoinedSwarm(uint256 indexed swarmId, uint256 agentId);
    event TaskCreated(uint256 indexed taskId, uint256 indexed swarmId, string description);
    event TaskCompleted(uint256 indexed taskId, address indexed agent, uint256 reward);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Create a swarm for multi-agent coordination
    function createSwarm(string calldata _name, uint256 _kagamiId) 
        external returns (uint256) {
        swarmCount++;
        swarms[swarmCount] = Swarm({
            id: swarmCount,
            name: _name,
            kagamiId: _kagamiId,
            coordinator: msg.sender,
            agentIds: new uint256[](0),
            active: true,
            createdAt: block.timestamp
        });
        
        emit SwarmCreated(swarmCount, _name, msg.sender);
        return swarmCount;
    }
    
    /// @notice Add agent to swarm
    function addAgentToSwarm(uint256 _swarmId, uint256 _agentId) external {
        Swarm storage swarm = swarms[_swarmId];
        require(swarm.active, "Swarm not active");
        require(msg.sender == swarm.coordinator, "Not coordinator");
        
        swarm.agentIds.push(_agentId);
        emit AgentJoinedSwarm(_swarmId, _agentId);
    }
    
    /// @notice Create a task for the swarm
    function createTask(uint256 _swarmId, string calldata _description, uint256 _reward) 
        external payable returns (uint256) {
        require(msg.value >= _reward, "Insufficient reward");
        
        taskCount++;
        tasks[taskCount] = Task({
            id: taskCount,
            swarmId: _swarmId,
            description: _description,
            reward: _reward,
            completed: false,
            assignedAgent: address(0)
        });
        
        swarmTasks[_swarmId].push(taskCount);
        
        emit TaskCreated(taskCount, _swarmId, _description);
        return taskCount;
    }
    
    /// @notice Complete task and pay agent
    function completeTask(uint256 _taskId, address _agent) external onlyOwner {
        Task storage task = tasks[_taskId];
        require(!task.completed, "Already completed");
        
        task.completed = true;
        task.assignedAgent = _agent;
        
        payable(_agent).transfer(task.reward);
        
        emit TaskCompleted(_taskId, _agent, task.reward);
    }
}
