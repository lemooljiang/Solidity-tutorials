// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AccessControl.sol";

interface TokenToPost{
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFromOrigin(address _to, uint256 _value) external returns (bool success);
}

contract Post is AccessControl {
    TokenToPost token = TokenToPost(0x01917467634CFB7f75a0510ABE5C40f2017a9CEf);
    
    uint public id = 0;
    uint level1 = 200 * 1e18;
    uint level2 = 400 * 1e18;
    uint level3 = 600 * 1e18;

    
    struct Article 
    {
        string hash;
        address authoraddr;
        address[] voted;
        uint[] amount;
    }
    
    mapping(uint => Article) public articles;
    
    event PostArticle(uint id, string t);
    
    function postArticle(string memory _hash)
        public 
    {       
        id += 1;
        articles[id].hash = _hash;
        articles[id].authoraddr = msg.sender;
        emit PostArticle(id, _hash);
    }
    
    function isVoted(uint _uid)
        public
        view
        returns(bool)
    {
        for(uint i = 0; i < articles[_uid].voted.length; i ++){
            if(msg.sender == articles[_uid].voted[i]){
                return true;
            }
        }
        return false;
    }

    function get(uint _uid) 
        public 
        view 
        returns (Article memory) 
    {
        return articles[_uid];
    }
    
    function voteLevelOne(uint _uid)
        public
    {
        require(!isVoted(_uid));
        if(msg.sender == owner || inSuperAdmins(msg.sender) || inAdmins(msg.sender)){
            token.transfer(articles[_uid].authoraddr, level1);
        } else {
            token.transferFromOrigin(articles[_uid].authoraddr, level1);
        }
        articles[_uid].voted.push(msg.sender);
        articles[_uid].amount.push(level1);
    }
    
    function voteLevelTwo(uint _uid)
        public
    {
        require(!isVoted(_uid));
        if(msg.sender == owner || inSuperAdmins(msg.sender) || inAdmins(msg.sender)){
            token.transfer(articles[_uid].authoraddr, level2);
        } else {
            token.transferFromOrigin(articles[_uid].authoraddr, level2);
        }
        articles[_uid].voted.push(msg.sender);
        articles[_uid].amount.push(level2);
    }
    
    function voteLevelThree(uint _uid)
        public
    {
        require(!isVoted(_uid));
        if(msg.sender == owner || inSuperAdmins(msg.sender) || inAdmins(msg.sender)){
            token.transfer(articles[_uid].authoraddr, level3);
        } else {
            token.transferFromOrigin(articles[_uid].authoraddr, level3);
        }
        articles[_uid].voted.push(msg.sender);
        articles[_uid].amount.push(level3);
    }
    
  
    function setLevel(uint _one, uint _two, uint _three)
        public
    {
        require(msg.sender == owner || inSuperAdmins(msg.sender));
        level1 = _one;
        level2 = _two;
        level3 = _three;
    }
    

    function getMessage()
        public
        view
        returns(uint, uint, uint)
    {
        return(level1, level2, level3);
    }
    
}
