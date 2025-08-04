// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;



interface IStHYPE {
    function stake(uint256 _amount) external;
    function unstake(uint256 _amount) external;
}