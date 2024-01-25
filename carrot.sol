// SPDX-License-Identifier: MIT

/*
CARROT ERC20 AirDrop Smart Contract.
      ___                     ___           ___           ___     
     /  /\      ___          /  /\         /  /\         /  /\    
    /  /::\    /  /\        /  /::|       /  /::|       /  /::\   
   /  /:/\:\  /  /:/       /  /:/:|      /  /:/:|      /  /:/\:\  
  /  /:/~/:/ /__/::\      /  /:/|:|__   /  /:/|:|__   /  /:/~/::\ 
 /__/:/ /:/  \__\/\:\__  /__/:/ |:| /\ /__/:/ |:| /\ /__/:/ /:/\:\
 \  \:\/:/      \  \:\/\ \__\/  |:|/:/ \__\/  |:|/:/ \  \:\/:/__\/
  \  \::/        \__\::/     |  |:/:/      |  |:/:/   \  \::/     
   \  \:\        /__/:/      |  |::/       |  |::/     \  \:\     
    \  \:\       \__\/       |  |:/        |  |:/       \  \:\    
     \__\/                   |__|/         |__|/         \__\/    

*/

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Carrot is ERC20, ERC20Burnable, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => bool) controllers;

    uint256 private _totalSupply;
    uint256 private MAXSUP;
    uint256 constant MAXIMUMSUPPLY=30000000*10**18;

    constructor(address initialOwner)
        ERC20("Carrot", "XCRT")
        Ownable(initialOwner) {
            _mint(msg.sender, 6000000*10**18);
        }

    function mint(address to, uint256 amount) external {
    require(controllers[msg.sender], "Only controllers can mint");
    require((MAXSUP+amount)<=MAXIMUMSUPPLY, "Maximum supply has been reached");
    _totalSupply = _totalSupply.add(amount);
    MAXSUP=MAXSUP.add(amount);
    _balances[to] = _balances[to].add(amount);
    _mint(to, amount);
  }

    function mintAirdrop(address[] calldata holder, uint256 amount) external {
    require(controllers[msg.sender], "Only controllers can mint");
    for (uint256 i = 0; i < holder.length; i++)
      _mint(holder[i], amount);
  }

    function burnFrom(address account, uint256 amount) public override {
      if (controllers[msg.sender]) {
          _burn(account, amount);
      }
      else {
          super.burnFrom(account, amount);
      }
  }

    function addController(address controller) external onlyOwner {
    controllers[controller] = true;
  }

  function removeController(address controller) external onlyOwner {
    controllers[controller] = false;
  }

  function totalSupply() public override view returns (uint256) {
    return _totalSupply;
  }

  function maxSupply() public pure returns (uint256) {
    return MAXIMUMSUPPLY;
  }

}