// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Enum {
    enum Country{China,America,Japan,Germany,Greece}
    Country country;
    Country constant defaultCountry = Country(0);//Country.China;
    
    function getDefaultCountry() public pure returns(string memory) {
        if(defaultCountry == Country.America)
            return 'America';
        else if(defaultCountry == Country.China)
            return 'China';
        else
            return 'Others';
    }
    
    function setCountry(Country value) public returns(string memory) {
        country = value; // Country(value), value为uint8类型
        if(value == Country.China) {
            return "中国";
        }
        else {
            return "其他国家";
        }
    }

    function getCountry() public view returns(string memory) {
        if(country == Country.China) {
            return 'China';

        }
        else {
            return 'Other Country';
        }
    }
}