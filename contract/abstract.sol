// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract AbstractContract {
    function add(uint m, uint n) public virtual returns(uint);
    function mul(uint m, uint n) public pure returns(uint) {
        return m * n;
    }
}

contract MyContract is AbstractContract {
    function add(uint m, uint n) public override returns(uint) {
        return m + n;
    }
}
contract MyContract2 is AbstractContract {
    function add(uint m, uint n) public override returns(uint) {
        return (m + n) * 2;
    }
}
contract NewContract {
    AbstractContract c = new MyContract2();
    //合约的实例化以实现不同合约中的方法
    function calc(uint m, uint n) public returns(uint) {
        return c.add(m,n) + c.mul(m,n);
    }
}