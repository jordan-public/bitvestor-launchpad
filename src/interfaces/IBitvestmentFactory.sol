// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "./IBitvestment.sol";

interface IBitvestmentFactory {
    function createBitvestment(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        uint256 _initialPrice
    ) external returns (IBitvestment bitvestment);
    function withdrawFees() external;
    function receiveFees() external payable;
    function lastBitvestment() external view returns (IBitvestment);
}