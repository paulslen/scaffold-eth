pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract is Ownable {

  event SetPurpose (address sender, string purpose);
  mapping(address => uint256) moverEthBalance;
  mapping(address => bool) moverWhitelist;

  constructor() payable {
    // what should we do on deploy?
  }

  function whitelistMover(address _addr) public onlyOwner {
    moverWhitelist[_addr] = true;
  }

  function escrowFunds(address _mover) external payable {
    moverEthBalance[_mover] += msg.value;
  }

  function withdraw() public {
    require(moverEthBalance[msg.sender] > 0 && moverWhitelist[msg.sender]);
    msg.sender.call{value: moverEthBalance[msg.sender]}("");
  }

  // to support receiving ETH by default
  receive() external payable {

  }
  fallback() external payable {}
}
