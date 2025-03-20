// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BloodDonationRegistry {
    struct Donor {
        string name;
        string bloodType;
        string contact;
        bool isAvailable;
    }

    struct Recipient {
        string name;
        string bloodType;
        string contact;
        bool isFulfilled;
    }

    mapping(address => Donor) public donors;
    mapping(address => Recipient) public recipients;
    address[] public donorList;
    address[] public recipientList;

    event DonorRegistered(address donorAddress, string name, string bloodType);
    event RecipientRegistered(address recipientAddress, string name, string bloodType);
    event DonationMatched(address donor, address recipient);

    function registerDonor(string memory _name, string memory _bloodType, string memory _contact) public {
        require(bytes(donors[msg.sender].name).length == 0, "Donor already registered");
        
        donors[msg.sender] = Donor(_name, _bloodType, _contact, true);
        donorList.push(msg.sender);
        emit DonorRegistered(msg.sender, _name, _bloodType);
    }

    function registerRecipient(string memory _name, string memory _bloodType, string memory _contact) public {
        require(bytes(recipients[msg.sender].name).length == 0, "Recipient already registered");
        
        recipients[msg.sender] = Recipient(_name, _bloodType, _contact, false);
        recipientList.push(msg.sender);
        emit RecipientRegistered(msg.sender, _name, _bloodType);
    }

    function matchDonation(address _donor, address _recipient) public {
        require(donors[_donor].isAvailable, "Donor is not available");
        require(!recipients[_recipient].isFulfilled, "Recipient already received donation");
        require(keccak256(abi.encodePacked(donors[_donor].bloodType)) == keccak256(abi.encodePacked(recipients[_recipient].bloodType)), "Blood types do not match");
        
        donors[_donor].isAvailable = false;
        recipients[_recipient].isFulfilled = true;
        emit DonationMatched(_donor, _recipient);
    }
    
    function getDonors() public view returns (address[] memory) {
        return donorList;
    }
    
    function getRecipients() public view returns (address[] memory) {
        return recipientList;
    }
}
