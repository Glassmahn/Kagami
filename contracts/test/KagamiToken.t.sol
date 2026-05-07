// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/KagamiToken.sol";

contract KagamiTokenTest is Test {
    KagamiToken public token;
    address public owner = address(0x1);
    address public user1 = address(0x2);
    
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 * 10**18;
    
    function setUp() public {
        vm.prank(owner);
        token = new KagamiToken();
    }
    
    function test_InitialSupply() public {
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
    }
    
    function test_StakeForReflection() public {
        uint256 stakeAmount = 1000 * 10**18;
        vm.prank(owner);
        token.transfer(user1, stakeAmount);
        
        vm.prank(user1);
        token.stakeForReflection(1, stakeAmount);
        
        assertEq(token.getReflectionStake(1, user1), stakeAmount);
    }
    
    function test_DistributeRevenue() public {
        vm.deal(address(this), 1 ether);
        token.distributeRevenue{value: 1 ether}();
    }
}
