// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleString {
    string storedData;
    mapping(uint => string) public people;
    uint public id = 0;
    event SimpleEvent(uint i, string t);

    function set(string memory message) public {       
        id += 1;
        people[id] = message;
        emit SimpleEvent(id, message);
    }

    function  reset(uint uid, string memory message) public {
        people[uid] = message;
    }

    function get(uint uid) public view returns (string memory) {
        return people[uid];
    }

}