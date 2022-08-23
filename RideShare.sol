// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract GasPump {
    address payable public pumpOwner;  
    uint public gasAmount;
    event Purchase(uint amount);
    mapping (address => uint) internal pumpBalance;

    constructor() {
        pumpOwner = payable(msg.sender);
        pumpBalance[address(this)] = 21000;
        gasAmount =  0.0025 ether;
    }

    function getPumpBalance() public view returns (uint) {
        return pumpBalance[address(this)];
    }

    function buyGas(uint amount) public payable {
        require(msg.value == amount * gasAmount, "You must pay at least 0.00083 ETH for a litre"); 
        require(pumpBalance[address(this)] >= amount, "Not enough gas in the Pump");        
        pumpBalance[address(this)] -= amount;
        pumpBalance[msg.sender] += amount;
        emit Purchase(msg.value);
    }

    function withdrawPayments() external payable {
        require(msg.sender == pumpOwner, "You are unauthorized.");
        pumpOwner.transfer(address(this).balance);
    }

    function restockPump(uint amount) public {
        require(msg.sender == pumpOwner, "You are not authorized");
        pumpBalance[address(this)] += amount;
    }  
}


/**
 * MAKING PAYMENTS:
To make payments at the gas station, a QR code initiating 
the smart contract would be provided on each gas pump.
This qr code can then be scanned by the buyers at the gas station connecting
their mobile wallets to the Gas Pump.
*/