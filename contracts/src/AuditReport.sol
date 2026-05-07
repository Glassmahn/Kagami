// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AuditReport
/// @notice Formal verifications + reports (repo #15)
contract AuditReport is Ownable {
    enum AuditStatus { PENDING, PASSED, FAILED, IN_PROGRESS }
    
    struct Audit {
        uint256 id;
        string contractName;
        string auditFirm;
        string reportURI; // IPFS hash
        AuditStatus status;
        uint256 completedAt;
        address requestedBy;
    }
    
    uint256 public auditCount;
    mapping(uint256 => Audit) public audits;
    mapping(string => uint256[]) public contractAudits;
    
    event AuditRequested(uint256 indexed auditId, string contractName);
    event AuditCompleted(uint256 indexed auditId, AuditStatus status, string reportURI);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Request an audit for a contract
    function requestAudit(string calldata _contractName, string calldata _auditFirm) 
        external returns (uint256) {
        auditCount++;
        audits[auditCount] = Audit({
            id: auditCount,
            contractName: _contractName,
            auditFirm: _auditFirm,
            reportURI: "",
            status: AuditStatus.PENDING,
            completedAt: 0,
            requestedBy: msg.sender
        });
        
        contractAudits[_contractName].push(auditCount);
        
        emit AuditRequested(auditCount, _contractName);
        return auditCount;
    }
    
    /// @notice Submit audit report (admin only)
    function submitReport(
        uint256 _auditId,
        string calldata _reportURI,
        AuditStatus _status
    ) external onlyOwner {
        Audit storage audit = audits[_auditId];
        require(audit.status == AuditStatus.PENDING || audit.status == AuditStatus.IN_PROGRESS, 
                "Invalid state");
        
        audit.reportURI = _reportURI;
        audit.status = _status;
        audit.completedAt = block.timestamp;
        
        emit AuditCompleted(_auditId, _status, _reportURI);
    }
    
    /// @notice Get all audits for a contract
    function getContractAudits(string calldata _contractName) 
        external view returns (uint256[] memory) {
        return contractAudits[_contractName];
    }
}
