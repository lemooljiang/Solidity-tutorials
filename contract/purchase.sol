// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Purchase {
    uint public value;
    address payable public seller;
    address payable public buyer;

    enum State { Created, Locked, Release, Finished }
    //定义合约的状态，初始为Created
    State public state;

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer);
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller);
        _;
    }

    modifier inState(State _state) {
        require(state == _state );
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    event SellerRefunded();

    //卖家创建合约时需提交物品价格的双倍做为押金。
    constructor() public payable {
        seller = msg.sender;
        value = msg.value / 2;
        require((2 * value) == msg.value);
    }

    //卖家提前终止合约，同时取回押金。
    function abort()
        public
        onlySeller
        inState(State.Created)
    {
        emit Aborted();
        state = State.Finished;
        seller.transfer(address(this).balance);
    }

    // 买家确认购买，提交价格+押金（双倍价格）
    function confirmPurchase()
        public
        inState(State.Created)
        condition(msg.value == (2 * value))
        payable
    {
        emit PurchaseConfirmed();
        buyer = msg.sender;
        state = State.Locked;
    }

    // 买家确认收到商品，取回押金
    function confirmReceived()
        public
        onlyBuyer
        inState(State.Locked)
    {
        emit ItemReceived();
        state = State.Release;
        buyer.transfer(value);
    }

    //卖家确认交易完成，取回价格+押金（3倍价格）
    function refundSeller()
        public
        onlySeller
        inState(State.Release)
    {
        emit SellerRefunded();
        state = State.Finished;
        seller.transfer(3 * value);
    }
}