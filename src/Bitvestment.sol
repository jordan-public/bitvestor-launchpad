// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IBitvestmentFactory.sol";
import "./interfaces/IBitvestment.sol";
import "./Token.sol";

contract Bitvestment is IBitvestment {
    IERC20 public token;
    IBitvestmentFactory public factory;
    uint256 public virtualNativeSupply;
    uint256 public constant FEE = 1 ether / 1000; // 0.1%

    constructor (
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        uint256 _initialPrice
    ) {
        factory = IBitvestmentFactory(msg.sender);
        token = new Token(_name, _symbol, _totalSupply); // All supply is sent to this contract
        virtualNativeSupply = _totalSupply * _initialPrice / 1 ether /*18 decimals*/;
    }

    function buy() external payable{
        factory.receiveFees{value: msg.value * FEE / 1 ether}();
        uint256 valueExFees = msg.value - msg.value * FEE / 1 ether;
        virtualNativeSupply += valueExFees;
        uint256 amount = valueExFees * token.totalSupply() / virtualNativeSupply;
        require(token.transfer(msg.sender, amount), "Transfer failed");
    }

    function sell(uint256 amountToSell) external {
        uint256 amountToPay = amountToSell * virtualNativeSupply / (token.totalSupply() + amountToSell);
        token.transferFrom(msg.sender, address(this), amountToSell); // Transfer tokens first to avoid reentrancy attack
        virtualNativeSupply -= amountToPay;
        factory.receiveFees{value: amountToPay * FEE / 1 ether}();
        payable(msg.sender).transfer(amountToPay * (1 ether - FEE) / 1 ether);
    }
}