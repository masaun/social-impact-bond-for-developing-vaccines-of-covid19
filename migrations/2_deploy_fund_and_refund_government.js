var FundAndRefundGovernment = artifacts.require("FundAndRefundGovernment");

//@dev - Import from exported file
var tokenAddressList = require('./tokenAddress/tokenAddress.js');
var contractAddressList = require('./contractAddress/contractAddress.js');
var walletAddressList = require('./walletAddress/walletAddress.js');


module.exports = function(deployer, network, accounts) {
    // Initialize owner address if you want to transfer ownership of contract to some other address
    let ownerAddress = walletAddressList["WalletAddress1"];

    deployer.deploy(FundAndRefundGovernment).then(async function(fundAndRefundGovernment) {
        if(ownerAddress && ownerAddress!="") {
            console.log(`=== Transfering ownerhip to address ${ownerAddress} ===`)
            await fundAndRefundGovernment.transferOwnership(ownerAddress);
        }
    });
};
