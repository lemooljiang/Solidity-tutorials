// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransferMany {
    constructor() payable public {
        
    }
    
    receive() external payable { }
    
    fallback () external payable { }
    
    function transferEths(address payable[]  memory _tos) payable public returns (bool) 
    {
        require(_tos.length > 0);
        // require(msg.sender == owner);
        for(uint32 i=0;i<_tos.length;i++){
          _tos[i].transfer(1 ether);
        }
       return true;
    }
}