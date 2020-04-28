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


export default class MarketplaceRegistry extends Component {
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
        this.getTestData = this.getTestData.bind(this);
    }

    _mintIdleToken = async () => {
        const { accounts, web3, idle_dai } = this.state;

        const mintAmount = 1.135;  // Expected transferred value is 1.05 DAI（= 1050000000000000000 Wei）
        let _mintAmount = web3.utils.toWei(mintAmount.toString(), 'ether');
        const _clientProtocolAmounts = [];

        let response = await idle_dai.methods.mintIdleToken(_mintAmount, _clientProtocolAmounts).send({ from: accounts[0] })
        console.log('=== response of mintIdleToken() function ===', response);        
    }

    getTestData = async () => {
        const { accounts, web3, marketplace_registry } = this.state;

        const _currentAccount = accounts[0];
        let balanceOf1 = await marketplace_registry.methods.balanceOfCurrentAccount(_currentAccount).call();
        console.log('=== response of balanceOfCurrentAccount() / 1 ===', balanceOf1);
 
        const _mintAmount = 105;  // Expected transferred value is 1.05 DAI（= 1050000000000000000 Wei）s
        let response = await marketplace_registry.methods.testFunc(_mintAmount).send({ from: accounts[0] })
        console.log('=== response of testFunc() function ===', response);

        let balanceOf2 = await marketplace_registry.methods.balanceOfCurrentAccount(_currentAccount).call();
        console.log('=== response of balanceOfCurrentAccount() / 2 ===', balanceOf2);
    }

    transferDAIFromUserToContract = async () => {
        const { accounts, web3, marketplace_registry, dai, MARKET_REGISTRY_ADDRESS } = this.state;

        const _mintAmount = 105;  // Expected transferred value is 1.05 DAI（= 1050000000000000000 Wei）s

        //@dev - Transfer DAI from UserWallet to DAI-contract
        let decimals = 18;
        let _amount = web3.utils.toWei((_mintAmount / ((10)**2)).toString(), 'ether');
        console.log('=== _amount ===', _amount);
        const _to = MARKET_REGISTRY_ADDRESS;
        let response1 = await dai.methods.transfer(_to, _amount).send({ from: accounts[0] });

        //@dev - Transfer DAI from DAI-contract to Logic-contract
        let response2 = await marketplace_registry.methods.transferDAIFromUserToContract(_mintAmount).send({ from: accounts[0] });  // wei
        console.log('=== response of transferDAIFromUserToContract() function ===', response2);
    }


    //////////////////////////////////// 
    ///// Refresh Values
    ////////////////////////////////////
    refreshValues = (instanceMarketplaceRegistry) => {
        if (instanceMarketplaceRegistry) {
          console.log('refreshValues of instanceMarketplaceRegistry');
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
     
        let MarketplaceRegistry = {};
        let Dai = {};
        let IdleToken = {};
        try {
          MarketplaceRegistry = require("../../../../build/contracts/MarketplaceRegistry.json");  // Load artifact-file of MarketplaceRegistry
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

            let instanceMarketplaceRegistry = null;
            let deployedNetwork = null;
            let MARKET_REGISTRY_ADDRESS = MarketplaceRegistry.networks[networkId.toString()].address;

            // Create instance of contracts
            if (MarketplaceRegistry.networks) {
              deployedNetwork = MarketplaceRegistry.networks[networkId.toString()];
              if (deployedNetwork) {
                instanceMarketplaceRegistry = new web3.eth.Contract(
                  MarketplaceRegistry.abi,
                  deployedNetwork && deployedNetwork.address,
                );
                console.log('=== instanceMarketplaceRegistry ===', instanceMarketplaceRegistry);
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


            if (MarketplaceRegistry) {
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
                marketplace_registry: instanceMarketplaceRegistry,
                dai: instanceDai,
                idle_dai: instanceIdleDAI,
                MARKET_REGISTRY_ADDRESS: MARKET_REGISTRY_ADDRESS,
                DAI_ADDRESS: DAI_ADDRESS,
                IDLE_DAI_ADDRESS: IDLE_DAI_ADDRESS
              }, () => {
                this.refreshValues(
                  instanceMarketplaceRegistry
                );
                setInterval(() => {
                  this.refreshValues(instanceMarketplaceRegistry);
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
        const { accounts, marketplace_registry } = this.state;

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

                            <Button size={'small'} mt={3} mb={2} onClick={this.getTestData}> Get Test Data </Button> <br />
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
