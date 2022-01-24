//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Treasure is Ownable {
    event Deposit(uint256 indexed);

    constructor() Ownable() {}

    function deposit() external payable virtual {
        payable(address(this)).transfer(msg.value);

        emit Deposit(msg.value);
    }

    receive() external payable {}

    function balance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
