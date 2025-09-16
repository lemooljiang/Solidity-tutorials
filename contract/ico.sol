// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface token {
    function transfer(address receiver, uint amount) external ;
    //代币合约的接口
}

contract Ico {
    address payable public beneficiary;
    uint public fundingGoal;
    uint public amountRaised;

    uint public deadline;
    uint public price;
    token public tokenReward;

    mapping(address => uint256) public balanceOf;
    bool crowdsaleClosed = false;

    event GoalReached(address recipient, uint totalAmountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution);

    constructor (
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint etherCostOfEachToken,
        address addressOfTokenUsedAsReward
    ) public {
        beneficiary = msg.sender;
        fundingGoal = fundingGoalInEthers * 1 ether;
        deadline = now + durationInMinutes * 1 minutes;
        price = etherCostOfEachToken * 1 ether;
        tokenReward = token(addressOfTokenUsedAsReward); //代币合约地址，以接口形式实现
    }
    
    receive() external payable {
        //给合约转以太币以换取代币 
        require(!crowdsaleClosed);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        tokenReward.transfer(msg.sender, amount / price);
        emit FundTransfer(msg.sender, amount, true);
    }
    
    fallback () external payable { }

    modifier afterDeadline() {
        if (now >= deadline) {
            _;
        }
    }

    function checkGoalReached() public afterDeadline {
        if (amountRaised >= fundingGoal) {
            emit GoalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
    }


    function safeWithdrawal() public afterDeadline {
        if (amountRaised < fundingGoal) {
            uint amount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
            if (amount > 0) {
                msg.sender.transfer(amount);
                emit FundTransfer(msg.sender, amount, false);
            }
        }

        if (fundingGoal <= amountRaised && beneficiary == msg.sender) {
            beneficiary.transfer(amountRaised);
            emit FundTransfer(beneficiary, amountRaised, false);
        }
    }
    
    function getEthBalance(address addr) public view returns (uint) {
        return addr.balance;
    }
}
