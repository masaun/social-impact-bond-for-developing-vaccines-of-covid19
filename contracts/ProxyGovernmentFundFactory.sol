pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

// Storage
import "./storage/McEvents.sol";

// Library
import "./lib/DaiAddressLib.sol";
import "./lib/IdleDaiAddressLib.sol";

// DAI
import "./DAI/dai.sol";

// idle.finance
import "./idle-contracts/contracts/IdleToken.sol";


/**
 * The ProxyContractForGovernmentFactory contract does this and that...
 */
contract ProxyGovernmentFundFactory {
    //@dev - Token Address
    address DAI_ADDRESS;
    address IDLE_DAI_ADDRESS;

    Dai public dai;  //@dev - dai.sol
    IdleToken public idleDAI;

    constructor() public {
        dai = Dai(DAI_ADDRESS);
        idleDAI = IdleToken(IDLE_DAI_ADDRESS);

        DAI_ADDRESS = DaiAddressLib.DaiAddress();
        IDLE_DAI_ADDRESS = IdleDaiAddressLib.IdleDaiAddress();
    }

    function transferDAI(address investorAddress, uint dividedAmount) public returns (bool) {
        address spender = msg.sender;
        dai.approve(spender, dividedAmount);
        dai.transfer(investorAddress, dividedAmount);

        //emit TransferDAI(spender, investorAddress, dividedAmount);
    }


    /***
     * @dev - Lend pooled fund(DAI) to idle.finance(idleDAI)
     **/
    function lendPooledFund(uint256 _mintAmount, uint256[] memory _clientProtocolAmounts) public returns (bool) {
        dai.approve(IDLE_DAI_ADDRESS, _mintAmount);
        idleDAI.mintIdleToken(_mintAmount, _clientProtocolAmounts);
    }
    
    /***
     * @dev - Redeem(=Withdraw) pooled fund(DAI) from idle.finance(idleDAI) to contract(this)
     *      - Service Provider redeem amount which they need from pooled fund each time
     **/
    function redeemPooledFund(uint256 _redeemAmount, bool _skipRebalance, uint256[] memory _clientProtocolAmounts) public returns (bool) {
        idleDAI.redeemIdleToken(_redeemAmount, _skipRebalance, _clientProtocolAmounts);
    }    
}
