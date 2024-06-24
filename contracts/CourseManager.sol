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
