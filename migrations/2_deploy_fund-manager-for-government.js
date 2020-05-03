var FundManagerForGovernment = artifacts.require("FundManagerForGovernment");

//@dev - Import from exported file
var tokenAddressList = require('./tokenAddress/tokenAddress.js');
var contractAddressList = require('./contractAddress/contractAddress.js');
var walletAddressList = require('./walletAddress/walletAddress.js');


module.exports = function(deployer, network, accounts) {
    // Initialize owner address if you want to transfer ownership of contract to some other address
    let ownerAddress = walletAddressList["WalletAddress1"];

    deployer.deploy(FundManagerForGovernment).then(async function(fundManagerForGovernment) {
        if(ownerAddress && ownerAddress!="") {
            console.log(`=== Transfering ownerhip to address ${ownerAddress} ===`)
            await fundManagerForGovernment.transferOwnership(ownerAddress);
        }
    });
};
