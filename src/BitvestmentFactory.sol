// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IBitvestmentFactory.sol";
import "./interfaces/IBitvestment.sol";
import "./Bitvestment.sol";
import "./Token.sol";

contract BitvestmentFactory is IBitvestmentFactory, Ownable {
    mapping(address => uint256) public tokenIndex; // into tokens array
    IERC20[] public tokens;
    IBitvestment[] public bitvestments;

    constructor () Ownable(msg.sender) {}

    function createBitvestment(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        uint256 _initialPrice
    ) external returns (IBitvestment bitvestment) {
        bitvestment = new Bitvestment(_name, _symbol, _totalSupply, _initialPrice);
        bitvestments.push(bitvestment);
        IERC20 _token = bitvestment.token();
        tokenIndex[address(_token)] = tokens.length;
        tokens.push(_token);
    }

    function withdrawFees() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function receiveFees() external payable {}
}