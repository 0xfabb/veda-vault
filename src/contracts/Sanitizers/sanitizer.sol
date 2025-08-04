// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract SanitizerGuards {
    mapping(address => bool) public Whitelist;

    modifier onlyEOA() {
        require(msg.sender == tx.origin, "No contracts allowed");
        _;
    }

    modifier onlyWhitelisted(address user) {
        require(Whitelist[user], "User not whitelisted");
        _;
    }

    modifier checkAmount(uint256 _amount) {
        require(_amount > 0, "Cannot deposit 0");
        _;
    }
}
