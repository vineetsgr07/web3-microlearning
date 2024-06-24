# 🌐 Web3 Microlearning Platform

![CI](https://github.com/vineetsgr07/web3-microlearning/actions/workflows/ci.yml/badge.svg)
![TS](https://badgen.net/badge/-/TypeScript?icon=typescript&label&labelColor=blue&color=555555)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](http://perso.crans.org/besson/LICENSE.html)

A Web3 microlearning platform built using Next.js, RainbowKit, Tailwind, IPFS, and smart contracts for decentralized and tokenized learning.

### Features

- Token-based rewards system for course completion
- NFT certificates for course completion
- Decentralized content storage using IPFS
- Course creation and management through smart contracts

### Getting Started

The `pnpm` CLI is the recommended package manager, but `npm` and `yarn` should work too.

```bash
pnpm install
```

Development

```bash
pnpm dev
```

Build

```bash
pnpm build
```

### Core Integrations

* RainbowKit: Wallet connection manager
- Sign-In With Ethereum: Account authentication
- IPFS: Decentralized content storage
- LearningToken: ERC20 token for rewarding users
- CertificateNFT: NFT certificates for course completion

### Smart Contracts

#### LearningToken.sol

```bash
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
```

#### CertificateNFT.sol

```bash
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
```

#### CourseManager.sol

```bash
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LearningToken.sol";
import "./CertificateNFT.sol";

contract CourseManager {
    struct Course {
        string name;
        string ipfsHash;
        uint256 reward;
    }

    address public owner;
    LearningToken public token;
    CertificateNFT public nft;
    mapping(uint256 => Course) public courses;
    mapping(uint256 => mapping(address => bool)) public courseCompletions;
    uint256 public courseCount;

    constructor(address tokenAddress, address nftAddress) {
        owner = msg.sender;
        token = LearningToken(tokenAddress);
        nft = CertificateNFT(nftAddress);
    }

    function createCourse(string memory name, string memory ipfsHash, uint256 reward) external {
        require(msg.sender == owner, "Only the owner can create courses");
        courseCount++;
        courses[courseCount] = Course(name, ipfsHash, reward);
    }

    function completeCourse(uint256 courseId) external {
        require(!courseCompletions[courseId][msg.sender], "Course already completed");
        courseCompletions[courseId][msg.sender] = true;
        token.rewardTokens(msg.sender, courses[courseId].reward);
        nft.issueCertificate(msg.sender);
    }
}
```

Acknowledgements:

Original template was forked from <https://github.com/wslyvh/nexth>

<hr/>
© 2024 Vineet Sagar
