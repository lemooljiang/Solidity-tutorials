// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//定义数据合约
contract storageStructure {
    //记录球员和分数
    address public implementation;//逻辑合约地址
    mapping(address=>uint256) public points;
    address public owner;
}

//定义逻辑合约
contract implementationV1 is storageStructure {
    modifier onlyowner()  {
        require(msg.sender == owner, "only owner can do");
        _;
    }
    //增加球员和分数
    function addPlayer(address player, uint256 point) public onlyowner {
        require(points[player] == 0, "player already exists");
        points[player] = point;
    }
    //修改球员和分数
    function setPlayer(address player, uint256 point) public onlyowner {
        require(points[player] != 0, "player must already exists");
        points[player] = point;
    }
}

//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//0x6fd075fc000000000000000000000000Ab8483F64d9C6d1EcF9b849Ae677dD3315835cb20000000000000000000000000000000000000000000000000000000000000061
//0x6fd075fc0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc40000000000000000000000000000000000000000000000000000000000000064
//0x6fd075fc000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb20000000000000000000000000000000000000000000000000000000000000064
//0x6fd075fc0000000000000000000000005B38Da6a701c568545dCfcB03FcB875f56beddC40000000000000000000000000000000000000000000000000000000000000062
//0x014892a4000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb20000000000000000000000000000000000000000000000000000000000000042

0x6fd075fc00000000000000000000000078731d3ca6b7e34ac0f824c42a7cc18a495cabab000000000000000000000000000000000000000000000000000000000000000a

//代理合约 代理合约调用逻辑合约的逻辑去修改本身（代理合约）的数据
contract proxy is storageStructure {
    modifier onlyowner()  {
        require(msg.sender == owner, "only owner can call");
        _;
    }
    
    constructor()  {
        owner = msg.sender;
    }
    
    //更新逻辑合约的地址
    function setImpl(address _impl) public onlyowner {
        implementation = _impl;
    }
    
    //fallback函数 调用逻辑合约中的函数，在本地（代理合约）执行
    fallback() external {
        address impl = implementation; //逻辑合约的地址
        require(impl != address(0), "implementation must exists");
        
        //底层调用
        assembly {
            //调用delegateccall
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            //delegatecall(g, a, in, insize, out, outsize)
            let result := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            
            //returndatacopy(t, f, s)
            returndatacopy(ptr, 0, size)
            
            switch result 
                case 0 { revert(ptr, size) }
                default { return(ptr, size) }   
        }
    }  
}
//calldata 就是input中的数据
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//0x6fd075fc0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc40000000000000000000000000000000000000000000000000000000000000064
//0x6fd075fc000000000000000000000000Ab8483F64d9C6d1EcF9b849Ae677dD3315835cb20000000000000000000000000000000000000000000000000000000000000066
0x6fd075fc000000000000000000000000617f2e2fd72fd9d5503197092ac168c91465e7f20000000000000000000000000000000000000000000000000000000000000038

//逻辑合约升级
contract implementationV2 is implementationV1 {
    function addPlayer(address player, uint256 point) override public onlyowner virtual {
        require(points[player] == 0, "player already exists");
        points[player] = point;
        totalPlayers ++;
    }
}