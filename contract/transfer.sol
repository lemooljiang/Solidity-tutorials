// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestAddr {

    constructor() public payable {

    }

    // 获取一个账号的余额，注意把地址替换为自己的账号地址
    function testBlance() public view returns (uint) {
        address a = 0x3D8caac0CB5f5BA177464f88B3cB5A7EfB426992;
        return a.balance;  // wei   1eth = 10e18wei
    }

    // 参看合约地址余额address(this)，在创建账号的时候附加一些以太币
    function testSelfBlance() public view returns (uint) {
        return address(this);
    }

    // 地址如何作为参数
    function balance(address a) public view returns (uint) {
        return a.balance;
    }

    function testTransfer(address payable a, uint x) public {
        //  转移1eth  （1eth  = 10^18wei）
        if (address(this).balance >= x * 1 ether) {
           // 思考谁来支付矿工费呢？查看一下合约余额
           a.transfer(x * 1 ether);
        }
        //由合约地址向a转帐，矿工费由发起人(msg.sender)承担
    }
}