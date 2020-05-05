var BokkyPooBahsDateTimeContract = artifacts.require("BokkyPooBahsDateTimeContract");

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(BokkyPooBahsDateTimeContract);
};



/***
 * Deployed information (Deployed address, etc...) on Kovan
 **/

// 2_deploy_bokkypoobahs-datetime-contract.js
// ==========================================
//
//    Deploying 'BokkyPooBahsDateTimeContract'
//    ----------------------------------------
//    > transaction hash:    0x1e97881664322aec44bb13e711a54f00983e990fd20663404879017410bfc3f8
//    > Blocks: 1            Seconds: 5
//    > contract address:    0x2ac864D31b541267A821408A952E954B6b2AC9eA
//    > block number:        18353293
//    > block timestamp:     1588643936
//    > account:             0xd91df4880c64343e10F75d8E5f281BcBa4318e4b
//    > balance:             0.480813715
//    > gas used:            1090641 (0x10a451)
//    > gas price:           5 gwei
//    > value sent:          0 ETH
//    > total cost:          0.005453205 ETH
//
//
//    > Saving migration to chain.
//    > Saving artifacts
//    -------------------------------------
//    > Total cost:         0.005453205 ETH
