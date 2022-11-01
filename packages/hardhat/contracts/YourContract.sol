pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract is Ownable {

  event SetPurpose (address sender, string purpose);
  mapping(address => uint256) public moverEthBalance;
  mapping(address => uint256) public userEthBalance;
  mapping(address => bool) public moverWhitelist;

  constructor() payable {
    // what should we do on deploy?
  }

  function whitelistMover(address _addr) public onlyOwner {
    moverWhitelist[_addr] = true;
  }

  function escrowFunds(address _mover) external payable {
    moverEthBalance[_mover] += msg.value;
  }

  function withdraw(address _to) public {
    uint withdrawalAmount = moverEthBalance[msg.sender];
    require(withdrawalAmount > 0 && moverWhitelist[msg.sender]);
    moverEthBalance[msg.sender] = 0;
    (bool sent, bytes memory data) = _to.call{value: withdrawalAmount}("");
    require(sent, "Failed to send Ether");
  }

  function increaseBalance(address _receiver, uint256 _value) public {
    moverEthBalance[_receiver] += _value;
  }

  function getMoverEthBalance(address _addr) public returns(uint256) {
    return moverEthBalance[_addr];
  }

  // to support receiving ETH by default
  receive() external payable {
    moverEthBalance[msg.sender] += msg.value;
  }
  fallback() external payable {}

  function contractBalance() public view returns (uint256) {
    return address(this).balance;
  }
}
