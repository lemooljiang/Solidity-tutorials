// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccessControl {
    address public owner;  //所有者
    address[] admins;     //管理员列表
    uint public x;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function isAdmin() public view returns(bool){
       //遍历管理员列表以判断是不是管理员
        for(uint i = 0; i < admins.length; i ++){
            if(msg.sender == admins[i]){
                return true;
            }
        }
        return false;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    
    modifier onlyAdmins() {
        require(isAdmin());
        _;
    }
    
    
    function addAdmin(address a) public onlyOwner{
      //只有所有者才能添加管理员
        admins.push(a);
    }
    
    function set(uint a) public onlyAdmins{
      //只有管理员才能调用此函数
        x = a;
    }
}