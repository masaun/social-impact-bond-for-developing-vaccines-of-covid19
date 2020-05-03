pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/math/SafeMath.sol";

// Use original Ownable.sol
import "./lib/OwnableOriginal.sol";

// Storage
import "./storage/McStorage.sol";
import "./storage/McConstants.sol";

// DAI
import "./DAI/dai.sol";

// idle.finance
import "./idle-contracts/contracts/IdleToken.sol";


contract FundAndRefundGovernment is OwnableOriginal(msg.sender), McStorage, McConstants {
    //@dev - Token Address
    address IDLE_DAI_ADDRESS;

    Dai public dai;  //@dev - dai.sol
    IERC20 public erc20;
    IdleToken public idleDAI;

    constructor() public {}

    /***
     * @dev - Government stake fund for payment for success
     **/
    //function stakeFundFromGovernment(uint _objectiveId, uint _governmentId, uint _stakeAmount) public returns (bool) {}

    /***
     * @dev - If outcome is not achieved until objective, staked fund is refunded to government
     **/
    function refundFundToGovernment(uint _governmentId, uint _refundAmount) public returns (bool) {}


    /***
     * @dev - If outcome is achieved until objective, staked fund is distributed from this contract to investors
     **/
    function payForSuccessful(uint _governmentId, uint _refundAmount) public returns (bool) {}

}
