// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }
    
    Contact[] private contacts;
    mapping(uint => uint) private idToIndex;
    uint private nextId = 1;
    
    error ContactNotFound(uint id);
    
    constructor(address _initialOwner) Ownable(_initialOwner) {}
    
    function addContact(
        string calldata _firstName,
        string calldata _lastName,
        uint[] calldata _phoneNumbers
    ) external onlyOwner {
        Contact memory newContact = Contact({
            id: nextId,
            firstName: _firstName,
            lastName: _lastName,
            phoneNumbers: _phoneNumbers
        });
        
        contacts.push(newContact);
        idToIndex[nextId] = contacts.length - 1;
        nextId++;
    }
    
    function deleteContact(uint _id) external onlyOwner {
        uint index = idToIndex[_id];
        
        // Check if contact exists (id must be > 0 and within bounds)
        if (_id == 0 || index >= contacts.length || contacts[index].id != _id) {
            revert ContactNotFound(_id);
        }
        
        // Move last element to deleted position
        uint lastIndex = contacts.length - 1;
        if (index != lastIndex) {
            Contact memory lastContact = contacts[lastIndex];
            contacts[index] = lastContact;
            idToIndex[lastContact.id] = index;
        }
        
        // Remove last element
        contacts.pop();
        delete idToIndex[_id];
    }
    
    function getContact(uint _id) external view returns (Contact memory) {
        uint index = idToIndex[_id];
        
        // Check if contact exists
        if (_id == 0 || index >= contacts.length || contacts[index].id != _id) {
            revert ContactNotFound(_id);
        }
        
        return contacts[index];
    }
    
    function getAllContacts() external view returns (Contact[] memory) {
        return contacts;
    }
}

contract AddressBookFactory {
    
    function deploy() external returns (address) {
        AddressBook newAddressBook = new AddressBook(msg.sender);
        return address(newAddressBook);
    }
}