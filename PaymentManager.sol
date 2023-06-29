// Simple Smart Contract: PaymentManager
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract PaymentManager {
    address public owner;
    uint256 public totalPayments;
    mapping(address => uint256) public payments;

    constructor() {
        owner = msg.sender;
    }

    // Function to make a payment
    function makePayment() external payable {
        require(msg.value > 0, "Payment amount must be greater than 0.");

        uint256 paymentAmount = msg.value;
        payments[msg.sender] += paymentAmount;
        totalPayments += paymentAmount;

        assert(totalPayments >= paymentAmount);

        if (paymentAmount > 10 ether) {
            revert("Payment amount exceeds the limit.");
        }
    }

    // Function to withdraw the accumulated payments (only callable by the contract owner)
    function withdrawPayments() external {
        require(msg.sender == owner, "Only the contract owner can withdraw payments.");

        uint256 paymentAmount = payments[msg.sender];
        require(paymentAmount > 0, "No payments available for withdrawal.");

        payments[msg.sender] = 0;
        totalPayments -= paymentAmount;

        payable(msg.sender).transfer(paymentAmount);
    }
}
