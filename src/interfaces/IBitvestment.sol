// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IBitvestmentFactory.sol";

interface IBitvestment {
    function token() external view returns (IERC20);
    function factory() external view returns (IBitvestmentFactory);
    function virtualNativeSupply() external view returns (uint256);
    function FEE() external pure returns (uint256);
    function buy() external payable;
    function sell(uint256 amountToSell) external;
}