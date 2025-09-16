// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface MyInterface {
    function add(uint m, uint n) external returns(uint);
    function mul(uint m, uint n) external returns(uint);
    
}


contract MyContract is MyInterface {
    function add(uint m, uint n) public override returns(uint) {
        return m + n;
    }
    function mul(uint m, uint n) public override returns(uint) {
        return m * n;
    }
}


contract NewContract {
    MyInterface my = new MyContract();
    function calc(uint m, uint n) public returns(uint) {
        return my.add(m,n) + my.mul(m,n);
    }
}