var IdlePriceCalculator = artifacts.require("./IdlePriceCalculator.sol");
var IdleFactory = artifacts.require("./IdleFactory.sol");
var IdleMcdBridge = artifacts.require("./IdleMcdBridge.sol");

const SAI = {
  'live': '0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359',
  'live-fork': '0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359', // needed for truffle
  'kovan': '0xC4375B7De8af5a38a93548eb8453a498222C4fF2',
  'kovan-fork': '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', // needed for truffle
  'rinkeby': '0x811e5cc5fddd395d488fe92c4f0f917f3ada6ab6',
  'rinkeby-fork': '0x811e5cc5fddd395d488fe92c4f0f917f3ada6ab6',  // needed for truffle
  'local': '0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359',
  'local-fork': '0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359',
  'test': '0xd6801a1DfFCd0a410336Ef88DeF4320D6DF1883e',
  'coverage': '0xd6801a1DfFCd0a410336Ef88DeF4320D6DF1883e',

  'deploy': '0x811e5cc5fddd395d488fe92c4f0f917f3ada6ab6',   // used for truffle Teams deploy, now rinkeby
  //'deploy': '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', // used for truffle Teams deploy, now kovan
};
const DAI = {
  'live': '0x6B175474E89094C44Da98b954EedeAC495271d0F',
  'live-fork': '0x6B175474E89094C44Da98b954EedeAC495271d0F', // needed for truffle
  'kovan': '0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa',
  'kovan-fork': '0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa', // needed for truffle
  'rinkeby': '0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa',
  'rinkeby-fork': '0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa', // needed for truffle
  'local': '0x6B175474E89094C44Da98b954EedeAC495271d0F',
  'local-fork': '0x6B175474E89094C44Da98b954EedeAC495271d0F',
  'test': '0x6B175474E89094C44Da98b954EedeAC495271d0F',
  'coverage': '0x6B175474E89094C44Da98b954EedeAC495271d0F',

  'deploy': '0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa',   // used for truffle Teams deploy, now rinkeby
  //'deploy': '0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa', // used for truffle Teams deploy, now kovan
};

module.exports = async function(deployer, network, accounts) {
  if (network === 'test') {
    return;
  }
  console.log(`### Deploying indipendent contract on ${network}`);

  await deployer.deploy(IdlePriceCalculator);
  await deployer.deploy(IdleFactory);
  await deployer.deploy(IdleMcdBridge, SAI[network], DAI[network]);

  console.log(`IdleMcdBridge.address ${IdleMcdBridge.address}`);
};
