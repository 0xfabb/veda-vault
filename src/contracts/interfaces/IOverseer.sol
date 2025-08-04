// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface IOverseer {
    function mint(address _user, string calldata communityCode) external;
    function balanceOf(address _user) external view returns (uint256);
    function burnAndRedeemIfPossible(address _user, uint256 _amount, string calldata communityCode) external returns (uint256);
    function redeem(uint256 burnId) external;
}
