var BokkyPooBahsDateTimeContract = artifacts.require("BokkyPooBahsDateTimeContract");

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(BokkyPooBahsDateTimeContract);
};
