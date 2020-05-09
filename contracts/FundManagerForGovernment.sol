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

// Contract
import "./SocialImpactBond.sol";


contract FundManagerForGovernment is OwnableOriginal(msg.sender), McStorage, McConstants {
    //@dev - Token Address
    address IDLE_DAI_ADDRESS;
    address SOCIAL_IMPACT_BOND;

    Dai public dai;  //@dev - dai.sol
    IERC20 public erc20;
    IdleToken public idleDAI;
    SocialImpactBond public socialImpactBond;


    constructor(address _erc20, address _socialImpactBond) public {
        dai = Dai(_erc20);
        erc20 = IERC20(_erc20);

        SOCIAL_IMPACT_BOND = _socialImpactBond;
    }

    /***
     * @dev - Government stake fund for payment for success
     **/
    function stakeFundFromGovernment(uint _objectiveId, uint _governmentId, uint _stakeAmount) public returns (bool) {
        //@dev - Call funded address which correspond to objectiveId
        Objective storage objective = objectives[_objectiveId];
        address _proxyContractForGovernmentFundAddress = address(objective.objectiveAddressForGovernmentFund);

        //@dev - Transfer from this contract address to funded address
        address spender = msg.sender;
        dai.approve(spender, _stakeAmount);
        dai.transfer(_proxyContractForGovernmentFundAddress, _stakeAmount);

        emit StakeFundFromGovernment(spender, _proxyContractForGovernmentFundAddress, _stakeAmount); 
    }


    /***
     * @dev - If outcome is not achieved until objective, staked fund (principal amounts) is refunded to government
     *      - In case of this, generated interest amount is distributed into investors
     **/
    function refundFundToGovernment(uint _objectiveId, uint _governmentId, uint _refundAmount) public returns (bool) {
        uint principalAmount;  // Staked fund amount == Public administration cost

        Objective memory objective = objectives[_objectiveId];

    }


    /***
     * @dev - If outcome is achieved until objective, staked fund is distributed from this contract to SocialImpactBond.sol contract (for investors)
     **/
    function payForSuccessful(address investorAddress, uint dividedAmount) public returns (bool) {
        address spender = msg.sender;
        dai.approve(spender, dividedAmount);
        dai.transfer(investorAddress, dividedAmount);

        emit PayForSuccessful(spender, investorAddress, dividedAmount);        
    }

    // function transferDAI(address investorAddress, uint dividedAmount) public returns (bool) {
    //     address spender = msg.sender;
    //     dai.approve(spender, dividedAmount);
    //     dai.transfer(investorAddress, dividedAmount);

    //     emit TransferDAI(spender, investorAddress, dividedAmount);
    // }


    /***
     * @dev - Getter function
     **/
    function balanceOfContract() public view returns (uint balanceOfContract_DAI, uint balanceOfContract_idleDAI) {
        return (dai.balanceOf(address(this)), idleDAI.balanceOf(address(this)));
    }
}
