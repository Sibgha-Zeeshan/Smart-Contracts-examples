// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/* Smart Contract for renting a car */

contract RentCar {
    
    //Storing status of Cars if available or booked
    enum Statuses { Available, Booked}
    Statuses public currentStatus;

    event Occupy(address _occupant, uint amount);

    address payable public owner;

    constructor(){
        owner = payable (msg.sender);
        currentStatus = Statuses.Available;
    }

    // Price check for renting car
    modifier priceCheck(uint _amount) {
        //if condition of require is true, proceed. Else it will not proceed
        require(msg.value >= _amount, "Amount you're paying is not enough");
        _;
    }

    // Status check of cars booked or available
    modifier statusCheck(){
        require(
            currentStatus == Statuses.Available, "Car is not available"
        );
        _;
    }
    // 
    function bookCar() public payable priceCheck(2 ether) statusCheck {
        currentStatus = Statuses.Booked;

        //Transferring money
        // owner.transfer(msg.value);
        (bool sent, bytes memory data) = owner.call{value: msg.value}("");
        require(
            sent
        );

        emit Occupy(msg.sender, msg.value);

    }

}