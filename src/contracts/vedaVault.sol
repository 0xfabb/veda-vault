// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IOverseer.sol";
import "./interfaces/IStHype.sol";
import "./Sanitizers/sanitizer.sol";

contract VedaVault is ERC20, Ownable, SanitizerGuards {
    IERC20 public immutable wHYPE;
    IStHYPE public immutable stHYPE;  // Changed from IERC20 to IStHYPE
    IOverseer public immutable overseer;
    string public communityCode;

    mapping(address => uint256[]) public userBurnIds;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event BurnInitiated(address indexed user, uint256 amount, uint256 burnId);
    event Redeemed(address indexed user, uint256 burnId);

    constructor(
        address _wHYPE,
        address _stHYPE,
        address _overseer,
        string memory _communityCode
    ) ERC20("Veda Vault HYPE", "vvHYPE") Ownable(msg.sender) {
        require(_wHYPE != address(0), "Invalid wHYPE address");
        require(_stHYPE != address(0), "Invalid stHYPE address");
        require(_overseer != address(0), "Invalid overseer address");

        wHYPE = IERC20(_wHYPE);
        stHYPE = IStHYPE(_stHYPE);  // Changed from IERC20 to IStHYPE
        overseer = IOverseer(_overseer);
        communityCode = _communityCode;
    }

    function deposit(uint256 _amount) external onlyEOA {
        checkAmount(_amount);
        require(wHYPE.transferFrom(msg.sender, address(this), _amount), "wHYPE transfer failed");
        require(wHYPE.approve(address(stHYPE), _amount), "Could'nt approve for wHype");  // Fixed typo

        stHYPE.stake(_amount);  // Now you can call directly without casting
        _mint(msg.sender, _amount);

        emit Deposited(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) external onlyEOA {
        checkAmount(_amount);
        require(balanceOf(msg.sender) >= _amount, "Insufficient vvHYPE");

        _burn(msg.sender, _amount);
        stHYPE.unstake(_amount);  // Now you can call directly without casting

        require(wHYPE.transfer(msg.sender, _amount), "wHYPE transfer back failed");

        emit Withdrawn(msg.sender, _amount);
    }

    function burnAndInitiateRedeem(uint256 _amount) external onlyEOA {
        require(_amount > 0, "Zero amount");

        _burn(msg.sender, _amount);
        uint256 burnId = overseer.burnAndRedeemIfPossible(msg.sender, _amount, communityCode);
        userBurnIds[msg.sender].push(burnId);

        emit BurnInitiated(msg.sender, _amount, burnId);
    }

    function redeem(uint256 burnId) external onlyEOA {
        overseer.redeem(burnId);
        emit Redeemed(msg.sender, burnId);
    }

    function totalVaultAssets() external view returns (uint256) {
        return wHYPE.balanceOf(address(this));
    }

    function userRealStake(address user) external view returns (uint256) {
        return overseer.balanceOf(user);
    }

    function whitelistAddress(address user) external onlyOwner {
        Whitelist[user] = true;
    }
}
