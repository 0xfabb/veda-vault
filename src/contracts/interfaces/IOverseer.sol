// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IOverseer {
    /// @notice Stake wHYPE into stHYPE
    /// @param to Address receiving the stHYPE
    /// @param communityCode Likely used to track strategy logic (you can pass a string like "LOOPING")
    function mint(address to, string memory communityCode) external payable;

    /// @notice Burn stHYPE and attempt to redeem wHYPE
    /// @param from Address of the stHYPE holder
    /// @param amount Amount of stHYPE to burn
    /// @param communityCode Same strategy code used in mint
    /// @return burnId ID for the redeem request (used to track status)
    function burnAndRedeemIfPossible(
        address from,
        uint256 amount,
        string memory communityCode
    ) external returns (uint256 burnId);

    /// @notice Redeem previously burned stHYPE (if available)
    /// @param burnId ID returned from `burnAndRedeemIfPossible`
    function redeem(uint256 burnId) external;
}
