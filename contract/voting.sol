// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
  mapping (string => uint ) public votesReceived;
  mapping (address => bool) private addrRecoded;
  string[] public candidateList = ["lemool", "jackey", "hello"];

  function totalVotesFor(string memory candidate) view public returns (uint) {
      return votesReceived[candidate];
  }

  function voteForCandidate(string memory candidate) payable public {
    require(!addrRecoded[msg.sender]);
    addrRecoded[msg.sender] = true;
    uint m = msg.value / 0.1 ether;
    votesReceived[candidate] += m;
  }
}