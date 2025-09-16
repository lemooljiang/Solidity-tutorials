// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./evidence.sol";

contract EvidenceFactory is IEvdence {
    
    address[] signers;
    mapping(string=>address) evi_keys;
    
    event NewEvidence(string  _evi, address _sender, address _eviAddr);
    
    constructor(address[] memory _signers) {
        for(uint256 i =0 ;i < _signers.length; i ++) {
            signers.push(_signers[i]);
        }
    }
    
    function verify(address _signer) override external view returns (bool) {
        for(uint256 i = 0; i < signers.length; i ++) {
            if (signers[i] == _signer) {
                return true;
            }
        }
        
        return false;
    }
    function getSigner(uint256 _index) override external view returns(address) {
        if(_index < signers.length) {
            return signers[_index];
        } else {
            return address(0);
        }
    }
    function getSignersSize() override external view returns (uint256) {
        return signers.length;
    }
    
    function newEvidence(string memory _evi, string memory _key) public returns (address) {
        Evidence evidence = new Evidence(_evi, address(this));
        
        evi_keys[_key] = address(evidence);
        
        emit NewEvidence(_evi, msg.sender, address(evidence));
        
        return address(evidence);
    }
    
    function getEvidence(string memory _key) public view returns (string memory, address[] memory, address[] memory) {
        address addr = evi_keys[_key];
        return Evidence(addr).getEvidence();
    }
    
    function sign(string memory _key) public returns (bool) {
        address addr = evi_keys[_key];
        return Evidence(addr).sign();
    }
    
    function isAllSigned(string memory _key) public view returns (bool, string memory) {
        address addr = evi_keys[_key];
        return Evidence(addr).isAllSigned();
    }
    
}