// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.0 <0.9.0;

contract FirstCoin {
    uint private amount = 22;

    function coinGetter() public view returns(uint) {
        return amount;
    }

    function incrementer() public {
        amount++;
    }

    function decrementer() public {
        amount--;
    }
}
