// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/KagamiStarter.sol";

contract KagamiStarterTest is Test {
    KagamiStarter public starter;
    address public owner = address(0x1);

    function setUp() public {
        vm.prank(owner);
        starter = new KagamiStarter("TestKagami", "TestReflection");
    }

    function test_CreateReflection() public {
        vm.expectEmit(true, false, false, true);
        emit KagamiStarter.ReflectionCreated(address(this), "TestKagami", block.timestamp);
        starter.createReflection("ipfs://test");
    }

    function test_UpdateReflectionType() public {
        vm.prank(owner);
        starter.updateReflectionType("NewType");
        assertEq(starter.reflectionType(), "NewType");
    }
}
