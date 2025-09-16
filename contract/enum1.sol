// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestEnum {
    // 使用枚举自定义一个类型 ActionChoices
    enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }

    // 定义一个ActionChoices类型的变量
    ActionChoices choice;

    //定义类型时可以直接赋值
    ActionChoices defaultChoice = ActionChoices.GoStraight;

    function setGoStraight() public {
        choice = ActionChoices.GoStraight;
    }

    function getChoice() public view returns (ActionChoices) {
        return choice;
    }

    function getDefaultChoice() public view returns (uint) {
        //可以显示地转换为整型
        return uint(defaultChoice);
    }
}