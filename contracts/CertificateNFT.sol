// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CertificateNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address public owner;

    constructor() ERC721("CertificateNFT", "CNFT") {
        owner = msg.sender;
    }

    function issueCertificate(address to) external returns (uint256) {
        require(msg.sender == owner, "Only the owner can issue certificates");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(to, newItemId);
        return newItemId;
    }
}
