// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BitvestmentFactory} from "../src/BitvestmentFactory.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        BitvestmentFactory bf = new BitvestmentFactory();

        console.log("Owner: ", address(this));
        console.log("BitvestmentFactory: ", address(bf));

        vm.stopBroadcast();
    }
}
