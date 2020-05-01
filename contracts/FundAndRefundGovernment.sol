pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

// Storage
import "./storage/McStorage.sol";
import "./storage/McConstants.sol";

// DAI
import "./DAI/dai.sol";

// idle.finance
import "./idle-contracts/contracts/IdleToken.sol";


contract FundAndRefundGovernment is Ownable(msg.sender), McStorage, McConstants {
    constructor() public {}

    /***
     * @dev - Government stake fund for payment for success
     **/
    function stakeFundFromGovernment(uint _objectiveId, uint _governmentId, uint _stakeAmount) public returns (bool) {}

    /***
     * @dev - If outcome is not achieved until objective, staked fund is refunded to government
     **/
    function refundFundToGovernment(uint _governmentId, uint _refundAmount) public returns (bool) {}

}
