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



/***
 * @notice - This contract is that ...
 **/
contract StakeholderRegistry is OwnableOriginal(msg.sender), McStorage, McConstants {
    using SafeMath for uint;

    //@dev - current IDs
    uint currentServiceProviderId = 1;
    uint currentInvestorId = 1;
    uint currentEvaluatorId = 1;
    uint currentGovernmentId = 1;

    //@dev - Token Address
    address IDLE_DAI_ADDRESS;

    Dai public dai;  //@dev - dai.sol
    IERC20 public erc20;
    IdleToken public idleDAI;

    constructor(address _erc20, address _idleDAI) public {
        dai = Dai(_erc20);
        erc20 = IERC20(_erc20);
        idleDAI = IdleToken(_idleDAI);

        IDLE_DAI_ADDRESS = _idleDAI;
    }


    /***
     * @dev - Stakeholder of Social Impact Bond
     * Service Provider - Institution for developing vaccines of COVID19
     * Investor
     * Evaluator
     * Government
     **/


    /***
     * @dev - Stakeholders register by using functions below
     **/     
    function registerServiceProvider() public returns (bool) {}

    function registerInvester(address _investorAddress) public returns (bool) {
        Investor storage investor = investors[currentInvestorId];
        investor.investorId = currentInvestorId;
        investor.investorAddress = _investorAddress;
        emit RegisterInvester(investor.investorId, investor.investorAddress);

        currentInvestorId++;
    }

    function registerEvaluator() public returns (bool) {}

    function registerGovernment() public returns (bool) {}


    /***
     * @dev - Get IDs
     **/
    function getInvestorId(address _investorAddress) public view returns (uint _investorId) {
        return investors[_investorAddress];
    }

    function getAllOfCurrentId() 
        public 
        view
        returns (uint _currentServiceProviderId, 
                 uint _currentInvestorId, 
                 uint _currentEvaluatorId, 
                 uint _currentGovernmentId) 
    {
        //@dev - current IDs
        return (currentServiceProviderId, 
                currentInvestorId, 
                currentEvaluatorId, 
                currentGovernmentId);
    }



}
