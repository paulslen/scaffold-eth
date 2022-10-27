// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

struct Payment{
        address recipient;
        uint256 amount;
    }

contract VolcanoCoin is Ownable {

    uint256 totalSupply = 10000;
    uint256 totalSupplyIncrement = 1000;
    event supplyChange(uint totalSupply);
    event transferEvent(uint amount, address receiver);
    
    Payment[] public payments;
    mapping(address => uint) public balances;
    mapping(address => Payment[]) public paymentRecords;

    constructor() {
        balances[owner()] = totalSupply;
    }

    function getBalance(address _address) public view returns(uint256) {
        uint256 balance = balances[_address];
        return balance;
    }

   // function viewPayment(address _address) public view returns(Payment[] memory) {
        //Payment[] memory _payments;
        //_payments = paymentRecords[msg.sender];
   //     return payments[_address]; // 0 is just the first tx for testing, but really I do not understand waht I should be returning here.
   // }

    function paymentsByAddress(address addr) public view returns (Payment[] memory) {
        return paymentRecords[addr];
    }

    function recordPayment(address _sender, address _receiver, uint256 _amount) public {
        Payment memory _payment;
        _payment.recipient = _receiver;
        _payment.amount = _amount;
        paymentRecords[_sender].push(_payment);
    }

    function getTotalSupply() public view returns(uint256) {
        return totalSupply;
    }

    function increaseSupply() public onlyOwner {
        totalSupply = totalSupply + totalSupplyIncrement;
        emit supplyChange(totalSupply);
    }

    function transfer(uint256 _amount, address _to) public {
        require(balances[msg.sender] > _amount);
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        recordPayment(msg.sender, _to, _amount);
        emit transferEvent({amount: _amount, receiver:_to});
    }

}