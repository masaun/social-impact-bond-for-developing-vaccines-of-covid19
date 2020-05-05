var SocialImpactBond = artifacts.require("SocialImpactBond");
var StakeholderRegistry = artifacts.require("StakeholderRegistry");
var IERC20 = artifacts.require("IERC20");

//@dev - Import from exported file
var tokenAddressList = require('./tokenAddress/tokenAddress.js');
var contractAddressList = require('./contractAddress/contractAddress.js');

const _erc20 = tokenAddressList["Kovan"]["DAI"];        // DAI address on Kovan
const _idleDAI = tokenAddressList["Kovan"]["IdleDAI"];  // IdleDAI address on Kovan
const _stakeholderRegistry = StakeholderRegistry.address;
const _bokkyPooBahsDateTimeContract = contractAddressList["Kovan"]["BokkyPooBahsDateTimeLibrary"]["BokkyPooBahsDateTimeContract"]

const depositedAmount = web3.utils.toWei("2.1");    // 2.1 DAI which is deposited in deployed contract. 

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(SocialImpactBond, _erc20, _idleDAI, _stakeholderRegistry, _bokkyPooBahsDateTimeContract);

    const socialImpactBond = await SocialImpactBond.deployed();

    const iERC20 = await IERC20.at(_erc20);

    //@dev - Transfer 2.1 DAI from deployer's address to contract address in advance
    await iERC20.transfer(socialImpactBond.address, depositedAmount);
};
