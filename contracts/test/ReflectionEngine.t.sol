// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/ReflectionEngine.sol";

contract ReflectionEngineTest is Test {
    ReflectionEngine public engine;
    address public creator = address(0x1);
    
    function setUp() public {
        vm.prank(creator);
        engine = new ReflectionEngine();
    }
    
    function test_CreateReflection() public {
        vm.prank(creator);
        uint256 id = engine.createReflection("ipfs://test1");
        
        (address _creator, , , , ) = engine.getReflection(id);
        assertEq(_creator, creator);
    }
    
    function test_CreateChildShard() public {
        vm.startPrank(creator);
        uint256 parentId = engine.createReflection("ipfs://parent");
        uint256 childId = engine.createChildShard(parentId, "ipfs://child");
        vm.stopPrank();
        
        (, , , uint256 childCount, ) = engine.getReflection(parentId);
        assertEq(childCount, 1);
        assertGt(childId, parentId);
    }
    
    function test_DistributeRevenue() public {
        vm.prank(creator);
        uint256 id = engine.createReflection("ipfs://test");
        
        engine.distributeRevenue{value: 1 ether}(id);
        
        (, , , , uint256 revenue) = engine.getReflection(id);
        assertEq(revenue, 1 ether);
    }
}
