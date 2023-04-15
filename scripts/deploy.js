const { task } = require("hardhat/config");
const { getAccount } = require("./helpers");


task("check-balance", "Prints out the balance of your account").setAction(async function (taskArguments, hre) {
    const account = getAccount();
    console.log(`Account balance for ${account.address}: ${await account.getBalance()}`);
});

task("deploy", "Deploys the NFT.sol contract")
.addParam("totalSupply", "The maximum supply of tokens to mint")
.setAction(async function (taskArguments, hre) {
    const { totalSupply } = taskArguments;
    const tktContractFactory = await hre.ethers.getContractFactory("TKTFactory", getAccount());
    const tkt = await tktContractFactory.deploy(totalSupply);
    console.log(`Contract deployed to address: ${tkt.address}`);
});
