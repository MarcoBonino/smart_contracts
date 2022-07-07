//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "ItemManager.sol";

contract Item {
    uint public priceInWei;
    bool public paid;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(msg.value == priceInWei, "We don't support partial payments: pay the full price in one transaction!");
        require(!paid, "Item is already paid!");
        paid = true;
        (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Delivery did not work");
    }
}