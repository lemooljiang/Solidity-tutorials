// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// define interface 
interface IEvdence {
    function verify(address _signer) external view returns (bool);
    function getSigner(uint256 _index) external view returns(address);
    function getSignersSize() external view returns (uint256);
}

contract Evidence {
    // data define 
    string evidence;
    address[] signers;// qian guo ming list 
    address public factoryAddr;
    
    //event define 
    event NewSignaturesEvidence(string _evi, address _sender);
    event AddRepeatSignaturesEvidence(string _evi, address _sender);
    event AddSignaturesEvidence(string _evi, address _sender);
    
    function callVerify(address _signer) public view returns (bool) {
        return IEvdence(factoryAddr).verify(_signer);
    }
    // function 
    constructor(string memory _evi, address _factory) {
        factoryAddr = _factory;
        require(callVerify(tx.origin), "_signer is not valid");
        evidence = _evi;
        signers.push(tx.origin);
        
        emit NewSignaturesEvidence(_evi, tx.origin);
    }
    
    // query 
    function getEvidence() public view returns (string memory, address[] memory, address[] memory) {
        uint256 iSize = IEvdence(factoryAddr).getSignersSize();
        address[] memory signerList = new address[](iSize);
        for(uint256 i = 0; i < iSize; i ++) {
            signerList[i] = IEvdence(factoryAddr).getSigner(i);
        }
        
        return (evidence, signerList, signers);
    }
    
    // sign 
    function sign() public returns (bool)  {
        require(callVerify(tx.origin), "_signer is not valid");
        if(isSigned(tx.origin)) {
            emit AddRepeatSignaturesEvidence(evidence, tx.origin);
            return true;
        }
        signers.push(tx.origin);
        emit AddSignaturesEvidence(evidence, tx.origin);
        return true;
    }
    
    // query is signed 
    function isSigned(address _signer) internal view returns (bool) {
        for(uint256 i = 0; i < signers.length; i ++) {
            if (signers[i] == _signer) {
                return true;
            }
        }
        
        return false;
    }
    
    function isAllSigned() public view returns (bool, string memory) {
        uint256 iSize = IEvdence(factoryAddr).getSignersSize();
        for(uint256 i = 0; i < iSize; i ++) {
            if(!isSigned(IEvdence(factoryAddr).getSigner(i))) {
                return (false, "");
            }
        }
        
        return (true, evidence);
    }
    
    
}
