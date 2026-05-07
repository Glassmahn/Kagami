// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/ReflectionEngine.sol";
import "../src/SeedFactory.sol";

contract SeedFactoryTest is Test {
    ReflectionEngine public engine;
    SeedFactory public factory;
    address public creator = address(0x1);
    
    function setUp() public {
        vm.prank(creator);
        engine = new ReflectionEngine();
        factory = new SeedFactory(address(engine));
    }
    
    function test_SeedIdea() public {
        string memory ideaURI = "ipfs://my-idea";
        
        vm.expectEmit(true, true, false, true);
        emit SeedFactory.IdeaSeeded(address(this), 1, ideaURI, block.timestamp);
        
        uint256 id = factory.seedIdea(ideaURI);
        assertEq(id, 1);
    }
    
    function test_SeedIdeaCreatesReflection() public {
        uint256 id = factory.seedIdea("ipfs://test");
        
        (address _creator, , , , ) = engine.getReflection(id);
        assertEq(_creator, address(this));
    }
}
