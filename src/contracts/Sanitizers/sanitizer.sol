// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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
}
