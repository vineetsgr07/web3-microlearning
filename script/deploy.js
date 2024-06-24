const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy LearningToken contract
  const Token = await ethers.getContractFactory("LearningToken");
  const token = await Token.deploy();
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  await token.deployed();
  console.log("LearningToken deployed to:", token.address);

  // Deploy CertificateNFT contract
  const NFT = await ethers.getContractFactory("CertificateNFT");
  const nft = await NFT.deploy();
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  await nft.deployed();
  console.log("CertificateNFT deployed to:", nft.address);

  // Deploy CourseManager contract
  const CourseManager = await ethers.getContractFactory("CourseManager");
  const manager = await CourseManager.deploy(token.address, nft.address);
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  await manager.deployed();
  console.log("CourseManager deployed to:", manager.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
