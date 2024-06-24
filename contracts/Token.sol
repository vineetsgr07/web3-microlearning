// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LearningToken is ERC20 {
    address public owner;

    constructor() ERC20("LearningToken", "LTN") {
        owner = msg.sender;
        _mint(owner, 1000000 * 10 ** decimals());
    }

    function rewardTokens(address to, uint256 amount) external {
        require(msg.sender == owner, "Only the owner can reward tokens");
        _transfer(owner, to, amount);
    }
}
