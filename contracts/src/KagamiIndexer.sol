// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title KagamiIndexer
/// @notice Custom real-time shard data indexer (repo #76)
contract KagamiIndexer is Ownable {
    struct IndexedReflection {
        uint256 id;
        address creator;
        string metadataURI;
        uint256 blockNumber;
        uint256 timestamp;
        uint256 parentId;
        uint256[] childIds;
    }
    
    mapping(uint256 => IndexedReflection) public indexedReflections;
    uint256[] public indexedReflectionIds;
    mapping(address => uint256[]) public creatorReflections;
    uint256 public latestBlock;
    
    event ReflectionIndexed(uint256 indexed reflectionId, uint256 blockNumber);
    event IndexUpdated(uint256 indexed reflectionId, uint256 latestBlock);
    
    constructor() Ownable(msg.sender) {}
    
    /// @notice Index a new reflection
    function indexReflection(
        uint256 _reflectionId,
        address _creator,
        string calldata _metadataURI,
        uint256 _parentId
    ) external onlyOwner {
        require(indexedReflections[_reflectionId].id == 0, "Already indexed");
        
        indexedReflections[_reflectionId] = IndexedReflection({
            id: _reflectionId,
            creator: _creator,
            metadataURI: _metadataURI,
            blockNumber: block.number,
            timestamp: block.timestamp,
            parentId: _parentId,
            childIds: new uint256[](0)
        });
        
        indexedReflectionIds.push(_reflectionId);
        creatorReflections[_creator].push(_reflectionId);
        
        // Add as child to parent if exists
        if (_parentId > 0 && indexedReflections[_parentId].id > 0) {
            indexedReflections[_parentId].childIds.push(_reflectionId);
        }
        
        if (block.number > latestBlock) {
            latestBlock = block.number;
        }
        
        emit ReflectionIndexed(_reflectionId, block.number);
    }
    
    /// @notice Update index for existing reflection
    function updateIndex(uint256 _reflectionId) external onlyOwner {
        require(indexedReflections[_reflectionId].id > 0, "Not indexed");
        
        indexedReflections[_reflectionId].blockNumber = block.number;
        indexedReflections[_reflectionId].timestamp = block.timestamp;
        
        if (block.number > latestBlock) {
            latestBlock = block.number;
        }
        
        emit IndexUpdated(_reflectionId, block.number);
    }
    
    /// @notice Get indexed reflection data
    function getIndexedReflection(uint256 _reflectionId) 
        external view returns (IndexedReflection memory) {
        return indexedReflections[_reflectionId];
    }
    
    /// @notice Get reflections by block range
    function getReflectionsByBlock(uint256 _fromBlock, uint256 _toBlock) 
        external view returns (uint256[] memory) {
        uint256[] memory temp = new uint256[](indexedReflectionIds.length);
        uint256 count = 0;
        
        for (uint256 i = 0; i < indexedReflectionIds.length; i++) {
            uint256 id = indexedReflectionIds[i];
            if (indexedReflections[id].blockNumber >= _fromBlock && 
                indexedReflections[id].blockNumber <= _toBlock) {
                temp[count++] = id;
            }
        }
        
        // Trim array
        uint256[] memory result = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = temp[i];
        }
        
        return result;
    }
    
    /// @notice Get reflections by creator
    function getReflectionsByCreator(address _creator) 
        external view returns (uint256[] memory) {
        return creatorReflections[_creator];
    }
    
    /// @notice Get total indexed count
    function getTotalIndexed() external view returns (uint256) {
        return indexedReflectionIds.length;
    }
    
    /// @notice Check if reflection is indexed
    function isIndexed(uint256 _reflectionId) external view returns (bool) {
        return indexedReflections[_reflectionId].id > 0;
    }
    
    /// @notice Get all indexed reflections (paginated)
    function getAllIndexed(uint256 _offset, uint256 _limit) 
        external view returns (uint256[] memory) {
        uint256 end = _offset + _limit;
        if (end > indexedReflectionIds.length) {
            end = indexedReflectionIds.length;
        }
        
        uint256[] memory result = new uint256[](end - _offset);
        for (uint256 i = _offset; i < end; i++) {
            result[i - _offset] = indexedReflectionIds[i];
        }
        
        return result;
    }
}
