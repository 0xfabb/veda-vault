// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Sanitizers/sanitizer.sol";

interface IOverseer {
    function mint(address _user, string calldata communityCode) external;
    function balanceOf(address _user) external view returns (uint256);
}

contract VedaVault is ERC20, Ownable, SanitizerGuards {
    IERC20 public immutable wHYPE;
    IOverseer public immutable overseer;
    string public communityCode;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(
        address _wHYPE,
        address _overseer,
        string memory _communityCode
    ) ERC20("Veda Vault HYPE", "vvHYPE") Ownable(msg.sender) {
        require(_wHYPE != address(0), "Invalid wHYPE address");
        require(_overseer != address(0), "Invalid overseer address");

        wHYPE = IERC20(_wHYPE);
        overseer = IOverseer(_overseer);
        communityCode = _communityCode;
    }

    function deposit(uint256 _amount) external onlyEOA {
        require(_amount > 0, "Cannot deposit 0");

        // Transfer wHYPE from user to vault
        require(wHYPE.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        // Mint stHYPE to user via overseer
        overseer.mint(msg.sender, communityCode);

        // Mint vvHYPE to user
        _mint(msg.sender, _amount);

        emit Deposited(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) external onlyEOA {
        require(_amount > 0, "Cannot withdraw 0");
        require(balanceOf(msg.sender) >= _amount, "Insufficient vvHYPE");

        _burn(msg.sender, _amount);
        require(wHYPE.transfer(msg.sender, _amount), "Transfer failed");

        emit Withdrawn(msg.sender, _amount);
    }

    function totalVaultAssets() external view returns (uint256) {
        return wHYPE.balanceOf(address(this));
    }

    function userRealStake(address user) external view returns (uint256) {
        return overseer.balanceOf(user);
    }

    // Admin-only function to whitelist an address
    function whitelistAddress(address user) external onlyOwner {
        Whitelist[user] = true;
    }
}
