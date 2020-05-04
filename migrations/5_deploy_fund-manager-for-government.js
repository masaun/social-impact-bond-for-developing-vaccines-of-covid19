var FundManagerForGovernment = artifacts.require("FundManagerForGovernment");
var SocialImpactBond = artifacts.require("SocialImpactBond");
var IERC20 = artifacts.require("IERC20");

//@dev - Import from exported file
var tokenAddressList = require('./tokenAddress/tokenAddress.js');
var contractAddressList = require('./contractAddress/contractAddress.js');
var walletAddressList = require('./walletAddress/walletAddress.js');

const _erc20 = tokenAddressList["Kovan"]["DAI"];        // DAI address on Kovan
const _socialImpactBond = SocialImpactBond.address;


module.exports = function(deployer, network, accounts) {
    // Initialize owner address if you want to transfer ownership of contract to some other address
    let ownerAddress = walletAddressList["WalletAddress1"];

    deployer.deploy(FundManagerForGovernment, _erc20, _socialImpactBond).then(async function(fundManagerForGovernment) {
        if(ownerAddress && ownerAddress!="") {
            console.log(`=== Transfering ownerhip to address ${ownerAddress} ===`)
            await fundManagerForGovernment.transferOwnership(ownerAddress);
        }
    });
};
