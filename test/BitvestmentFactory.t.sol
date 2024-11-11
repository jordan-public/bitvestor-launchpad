// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IBitvestmentFactory} from "../src/interfaces/IBitvestmentFactory.sol";
import {BitvestmentFactory} from "../src/BitvestmentFactory.sol";
import {IBitvestment} from "../src/interfaces/IBitvestment.sol";

contract BitvestmentFactoryTest is Test {
    BitvestmentFactory public factory;
    IBitvestment public bitvestment;
    IERC20 public token;

    receive() external payable {}

    function setUp() public {
        factory = new BitvestmentFactory();
        bitvestment = factory.createBitvestment("MyToken", "TKN", 1000000 ether, 1 ether / 1000000); // 1M TKN for 1 ETH (actually BTC)
        token = bitvestment.token();
    }

    function test_Buy() public {
        uint256 balanceBefore = token.balanceOf(address(this));
        uint256 value = 1 ether / 1000;
        uint256 feesBefore = address(factory).balance;
        bitvestment.buy{value: value}();
        uint256 balanceAfter = token.balanceOf(address(this));
        assert(balanceAfter > balanceBefore); // 1M TKN for 1 ETH
        assert(address(factory).balance > feesBefore); // 0.1% fee
    }

    function test_BuySell() public {
        uint256 value = 1 ether / 1000;
        bitvestment.buy{value: value}();
        uint256 balanceBefore = token.balanceOf(address(this));
        console.log("balanceBefore", balanceBefore);
        uint256 amountToSell = 10 ether; // 1000 TKN
        uint256 feesBefore = address(factory).balance;
        token.approve(address(bitvestment), amountToSell);
        bitvestment.sell(amountToSell);
        uint256 balanceAfter = token.balanceOf(address(this));
        assert(balanceAfter < balanceBefore); // 1M TKN for 1 ETH
        assert(address(factory).balance > feesBefore); // 0.1% fee
    }

}
