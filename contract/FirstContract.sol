// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStorage {
    uint storedData;

    event Set(uint value);  // 事件是不需要实现的。
    Circle c;

    // 自定义类型
    struct Circle {
        uint radius;
    }

    // 定义一个函数修改器
    modifier mustOver10 (uint value) {
        require(value >= 10);
        _;
    }

    function set(uint x) public mustOver10(x) {
        storedData = x;
        c = Circle(x);
        emit Set(x);
    }

    function get() public view returns (uint) {
        return storedData;
    }

}