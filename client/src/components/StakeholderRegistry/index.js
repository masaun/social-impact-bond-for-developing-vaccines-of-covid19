import React, { Component } from "react";
import getWeb3, { getGanacheWeb3, Web3 } from "../../utils/getWeb3";

import App from "../../App.js";

import { Typography, Grid, TextField } from '@material-ui/core';
import { ThemeProvider } from '@material-ui/styles';
import { theme } from '../../utils/theme';
import { Loader, Button, Card, Input, Heading, Table, Form, Flex, Box, Image, EthAddress } from 'rimble-ui';
import { zeppelinSolidityHotLoaderOptions } from '../../../config/webpack';

import styles from '../../App.module.scss';
//import './App.css';

import { walletAddressList } from '../../data/walletAddress/walletAddress.js'
import { contractAddressList } from '../../data/contractAddress/contractAddress.js'
import { tokenAddressList } from '../../data/tokenAddress/tokenAddress.js'


export default class StakeholderRegistry extends Component {
    constructor(props) {    
        super(props);

        this.state = {
            /////// Default state
            storageValue: 0,
            web3: null,
            accounts: null,
            route: window.location.pathname.replace("/", "")
        };

        this._mintIdleToken = this._mintIdleToken.bind(this);
        this._redeemPooledFund = this._redeemPooledFund.bind(this);
        this._createProxyContract = this._createProxyContract.bind(this);
    }

    _mintIdleToken = async () => {
        const { accounts, web3, dai, idle_dai, IDLE_DAI_ADDRESS } = this.state;

        const mintAmount = 1.135;  // Expected transferred value is 1.135 DAI（= 1135000000000000000 Wei）
        let _mintAmount = web3.utils.toWei(mintAmount.toString(), 'ether');
        const _clientProtocolAmounts = [];

        let res1 = await dai.methods.approve(IDLE_DAI_ADDRESS, _mintAmount).send({ from: accounts[0] });
        console.log('=== response of approve() function ===', res1);  

        let res2 = await idle_dai.methods.mintIdleToken(_mintAmount, _clientProtocolAmounts).send({ from: accounts[0] });
        console.log('=== response of mintIdleToken() function ===', res2);        
    }

    _lendPooledFund = async () => {
        const { accounts, web3, social_impact_bond, stakeholder_registry, dai, idle_dai, IDLE_DAI_ADDRESS } = this.state;

        const mintAmount = 0.1;  // Expected transferred value is 0.1 DAI（= 10000000000000000 Wei）
        let _mintAmount = web3.utils.toWei(mintAmount.toString(), 'ether');
        const _clientProtocolAmounts = [];

        let res1 = await social_impact_bond.methods.lendPooledFund(_mintAmount, _clientProtocolAmounts).send({ from: accounts[0] });
        console.log('=== response of lendPooledFund() function ===\n', res1);        
    }

    _redeemPooledFund = async () => {
        const { accounts, web3, social_impact_bond, stakeholder_registry, dai, idle_dai, IDLE_DAI_ADDRESS } = this.state;

        const redeemAmount = 0.1;  // Expected transferred value is 0.1 DAI（= 10000000000000000 Wei）
        let _redeemAmount = web3.utils.toWei(redeemAmount.toString(), 'ether');
        const _skipRebalance = false;
        const _clientProtocolAmounts = [];

        let res1 = await social_impact_bond.methods.redeemPooledFund(_redeemAmount, _skipRebalance, _clientProtocolAmounts).send({ from: accounts[0] });
        console.log('=== response of redeemPooledFund() function ===\n', res1);            
    }

    _balanceOfContract = async () => {
        const { accounts, web3, social_impact_bond, stakeholder_registry, dai, idle_dai, IDLE_DAI_ADDRESS } = this.state;

        let res1 = await social_impact_bond.methods.balanceOfContract().call();
        console.log('=== response of balanceOfContract() function ===\n', res1);
    }

    _createProxyContract = async () => {
        const { accounts, web3, social_impact_bond } = this.state;

        let res1 = await social_impact_bond.methods.createProxyContract().send({ from: accounts[0] });
        console.log('=== response of createProxyContract() function ===\n', res1);
    }



    //////////////////////////////////// 
    ///// Refresh Values
    ////////////////////////////////////
    refreshValues = (instanceStakeholderRegistry) => {
        if (instanceStakeholderRegistry) {
          //console.log('refreshValues of instanceStakeholderRegistry');
        }
    }


    //////////////////////////////////// 
    ///// Ganache
    ////////////////////////////////////
    getGanacheAddresses = async () => {
        if (!this.ganacheProvider) {
            this.ganacheProvider = getGanacheWeb3();
        }
        if (this.ganacheProvider) {
            return await this.ganacheProvider.eth.getAccounts();
        }
        return [];
    }

    componentDidMount = async () => {
        const hotLoaderDisabled = zeppelinSolidityHotLoaderOptions.disabled;
     
        let StakeholderRegistry = {};
        let SocialImpactBond = {};
        let Dai = {};
        let IdleToken = {};
        try {
          StakeholderRegistry = require("../../../../build/contracts/StakeholderRegistry.json");  // Load artifact-file of StakeholderRegistry
          SocialImpactBond = require("../../../../build/contracts/SocialImpactBond.json");  // Load artifact-file of SocialImpactBond
          Dai = require("../../../../build/contracts/Dai.json");               //@dev - DAI（Underlying asset）
          IdleToken = require("../../../../build/contracts/IdleToken.json");   //@dev - IdleToken（IdleDAI）
        } catch (e) {
          console.log(e);
        }

        try {
          const isProd = process.env.NODE_ENV === 'production';
          if (!isProd) {
            // Get network provider and web3 instance.
            const web3 = await getWeb3();
            let ganacheAccounts = [];

            try {
              ganacheAccounts = await this.getGanacheAddresses();
            } catch (e) {
              console.log('Ganache is not running');
            }

            // Use web3 to get the user's accounts.
            const accounts = await web3.eth.getAccounts();
            // Get the contract instance.
            const networkId = await web3.eth.net.getId();
            const networkType = await web3.eth.net.getNetworkType();
            const isMetaMask = web3.currentProvider.isMetaMask;
            let balance = accounts.length > 0 ? await web3.eth.getBalance(accounts[0]): web3.utils.toWei('0');
            balance = web3.utils.fromWei(balance, 'ether');

            let instanceStakeholderRegistry = null;
            let deployedNetwork = null;
            let STAKEHOLDER_REGISTRY_ADDRESS = StakeholderRegistry.networks[networkId.toString()].address;

            // Create instance of contracts
            if (StakeholderRegistry.networks) {
              deployedNetwork = StakeholderRegistry.networks[networkId.toString()];
              if (deployedNetwork) {
                instanceStakeholderRegistry = new web3.eth.Contract(
                  StakeholderRegistry.abi,
                  deployedNetwork && deployedNetwork.address,
                );
                console.log('=== instanceStakeholderRegistry ===', instanceStakeholderRegistry);
              }
            }

            let instanceSocialImpactBond = null;
            let SOCIAL_IMPACT_BOND_ADDRESS = SocialImpactBond.networks[networkId.toString()].address;

            // Create instance of contracts
            if (SocialImpactBond.networks) {
              deployedNetwork = SocialImpactBond.networks[networkId.toString()];
              if (deployedNetwork) {
                instanceSocialImpactBond = new web3.eth.Contract(
                  SocialImpactBond.abi,
                  deployedNetwork && deployedNetwork.address,
                );
                console.log('=== instanceSocialImpactBond ===', instanceSocialImpactBond);
              }
            }


            //@dev - Create instance of DAI-contract
            let instanceDai = null;
            let DAI_ADDRESS = tokenAddressList["Kovan"]["DAI"]; //@dev - DAI（on Kovan）
            instanceDai = new web3.eth.Contract(
              Dai.abi,
              DAI_ADDRESS,
            );
            console.log('=== instanceDai ===', instanceDai);

            //@dev - Create instance of DAI-contract
            let instanceIdleDAI = null;
            let IDLE_DAI_ADDRESS = tokenAddressList["Kovan"]["IdleDAI"];  // IdleDAI (on Kovan)
            instanceIdleDAI = new web3.eth.Contract(
              IdleToken.abi,
              IDLE_DAI_ADDRESS,
            );
            console.log('=== instanceIdleDAI ===', instanceIdleDAI);


            if (StakeholderRegistry || SocialImpactBond) {
              // Set web3, accounts, and contract to the state, and then proceed with an
              // example of interacting with the contract's methods.
              this.setState({ 
                web3, 
                ganacheAccounts, 
                accounts, 
                balance, 
                networkId, 
                networkType, 
                hotLoaderDisabled,
                isMetaMask, 
                stakeholder_registry: instanceStakeholderRegistry,
                social_impact_bond: instanceSocialImpactBond,
                dai: instanceDai,
                idle_dai: instanceIdleDAI,
                STAKEHOLDER_REGISTRY_ADDRESS: STAKEHOLDER_REGISTRY_ADDRESS,
                DAI_ADDRESS: DAI_ADDRESS,
                IDLE_DAI_ADDRESS: IDLE_DAI_ADDRESS
              }, () => {
                this.refreshValues(
                  instanceStakeholderRegistry
                );
                setInterval(() => {
                  this.refreshValues(instanceStakeholderRegistry);
                }, 5000);
              });
            }
            else {
              this.setState({ web3, ganacheAccounts, accounts, balance, networkId, networkType, hotLoaderDisabled, isMetaMask });
            }
          }
        } catch (error) {
          // Catch any errors for any of the above operations.
          alert(
            `Failed to load web3, accounts, or contract. Check console for details.`,
          );
          console.error(error);
        }
    }


    render() {
        const { accounts, stakeholder_registry } = this.state;

        return (
            <div className={styles.widgets}>
                <Grid container style={{ marginTop: 32 }}>
                    <Grid item xs={12}>
                        <Card width={"auto"} 
                              maxWidth={"420px"} 
                              mx={"auto"} 
                              my={5} 
                              p={20} 
                              borderColor={"#E8E8E8"}
                        >
                            <h4>idle Insurance Fund</h4> <br />
                            <Button size={'small'} mt={3} mb={2} onClick={this._mintIdleToken}> Mint IdleToken（Mint IdleDAI） </Button> <br />

                            <Button size={'small'} mt={3} mb={2} onClick={this._lendPooledFund}> Lend Pooled Fund（Mint IdleDAI） </Button> <br />

                            <Button size={'small'} mt={3} mb={2} onClick={this._redeemPooledFund}> Redeem Pooled Fund（Redeem IdleDAI） </Button> <br />

                            <Button size={'small'} mt={3} mb={2} onClick={this._createProxyContract}> Create Proxy Contract </Button> <br />

                            <Button mainColor="DarkCyan" size={'small'} mt={3} mb={2} onClick={this._balanceOfContract}> Balance of contract </Button> <br />
                        </Card>
                    </Grid>

                    <Grid item xs={4}>
                    </Grid>

                    <Grid item xs={4}>
                    </Grid>
                </Grid>
            </div>
        );
    }

}
