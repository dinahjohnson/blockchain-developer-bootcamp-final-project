// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Gringotts {
  struct User {
    bool enrolled;
    uint balance;
    uint timestamp;
    uint withdrawalCount;
    uint depositCount;
  }

  mapping (address => User) private users;

  event LogNewUser(address accountAddress);
  event LogDeposit(address accountAddress, uint depositAmount);
  event LogWithdrawal(address accountAddress,uint withdrawalAmount, uint updatedBalance);
  event LogBalance(uint balance);
  
  // function () external payable {
  //     revert();
  // }

  function addUser() 
    public
  {
    require(!users[msg.sender].enrolled, "User is enrolled");

    users[msg.sender] = User ({
      enrolled: true,
      balance: 0,
      timestamp: 0,
      withdrawalCount: 0,
      depositCount: 0
    });

    emit LogNewUser(msg.sender);
  }

  function getBalance() 
    public
    view
    returns (uint) 
  {
    return users[msg.sender].balance;
  }

  function deposit() 
    public
    payable
    returns (uint)
  {
    users[msg.sender].balance += msg.value;
    users[msg.sender].depositCount++;

    if(users[msg.sender].depositCount == 1) {
      users[msg.sender].timestamp = block.timestamp;
    }

    emit LogDeposit(msg.sender, msg.value);
    return (users[msg.sender].balance);
  }

  function withdraw(uint withdrawAmount)
    public
    payable
    returns (uint) 
  {
    require(users[msg.sender].balance >= withdrawAmount, "Insufficient funds");
    
    address payable _user = payable(msg.sender);
    users[msg.sender].balance -= withdrawAmount;
    _user.transfer(withdrawAmount);
    
    // Reset timestamp and increment withdrawal account
    users[msg.sender].timestamp = 0;
    users[msg.sender].withdrawalCount++;
    
    emit LogWithdrawal(msg.sender, withdrawAmount, users[msg.sender].balance);
    return users[msg.sender].balance;
  }

}