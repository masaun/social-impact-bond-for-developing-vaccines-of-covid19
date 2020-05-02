var StakeholderRegistry = artifacts.require("StakeholderRegistry");

//@dev - Import from exported file
var tokenAddressList = require('./tokenAddress/tokenAddress.js');
var contractAddressList = require('./contractAddress/contractAddress.js');

const _erc20 = tokenAddressList["Kovan"]["DAI"];        // DAI address on Kovan
const _idleDAI = tokenAddressList["Kovan"]["IdleDAI"];  // IdleDAI address on Kovan

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(StakeholderRegistry, _erc20, _idleDAI);
};
