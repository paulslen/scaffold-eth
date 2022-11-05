// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

struct Payment{
        address recipient;
        uint256 amount;
    }

contract VolcanoCoin is Ownable, ERC20{

    uint256 totSupply = 10000;
    uint256 totalSupplyIncrement = 1000;
    event supplyChange(uint totSupply);
    event transferEvent(uint amount, address receiver);
    
    Payment[] public payments;
    mapping(address => uint) public balances;
    mapping(address => Payment[]) public paymentRecords;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(owner(), totSupply);
    }

    function getBalance(address _address) public view returns(uint256) {
        uint256 balance = balances[_address];
        return balance;
    }

    function paymentsByAddress(address addr) public view returns (Payment[] memory) {
        return paymentRecords[addr];
    }

    function recordPayment(address _sender, address _receiver, uint256 _amount) public {
        Payment memory _payment;
        _payment.recipient = _receiver;
        _payment.amount = _amount;
        paymentRecords[_sender].push(_payment);
    }

    function getTotSupply() public view returns(uint256) {
        return totSupply;
    }

    function increaseSupply() public onlyOwner {
        totSupply = totSupply + totalSupplyIncrement;
        emit supplyChange(totSupply);
    }

    function transfer(uint256 _amount, address _to) public {
        require(balances[msg.sender] > _amount);
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        recordPayment(msg.sender, _to, _amount);
        emit transferEvent({amount: _amount, receiver:_to});
    }

}