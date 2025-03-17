// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    ExampleExternalContract public exampleExternalContract;

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    }
uint256 public constant threshold = 1 ether;
mapping ( address => uint256 ) public balances;

event Stake(address,uint256);
    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)
function stake() public payable {
    require(!completed, "Contract is already completed");
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
}
uint256 public deadline = block.timestamp + 30 seconds;
bool public openForWithdrawal = false;
bool public completed = false;
    // After some `deadline` allow anyone to call an `execute()` function
    // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
function execute() public {
    require(!completed, "Already completed");
    require(block.timestamp >= deadline, "Deadline has not passed");
if(address(this).balance >= threshold){
    exampleExternalContract.complete{value: address(this).balance}();
}
else{
    openForWithdrawal = true;
}
completed = true;

}
 function withdraw() public {
    require(openForWithdrawal, "Withdrawal is not open");
    uint256 balance = balances[msg.sender];
    balances[msg.sender] = 0;
    payable(msg.sender).transfer(balance);
 }
    // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance

    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
 function timeLeft() public view returns (uint256) {
    if(block.timestamp >= deadline){
        return 0;
    }
    else{
        return deadline - block.timestamp;
    }
 }
 
   // Add the `receive()` special function that receives eth and calls stake()
   receive() external payable {
    stake();
   }
}
