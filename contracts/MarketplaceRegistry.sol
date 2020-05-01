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



/***
 * @notice - This contract is that ...
 **/
contract MarketplaceRegistry is Ownable, McStorage, McConstants {
    using SafeMath for uint;

    //@dev - current IDs
    uint currentServiceProviderId;
    uint currentInvestorId;
    uint currentEvaluatorId;
    uint currentGovernmentId;

    //@dev - Token Address
    address IDLE_DAI_ADDRESS;
    address underlyingERC20;

    Dai public dai;  //@dev - dai.sol
    IERC20 public erc20;
    IdleToken public idleDAI;

    constructor(address _erc20, address _idleDAI) public {
        dai = Dai(_erc20);
        erc20 = IERC20(_erc20);
        idleDAI = IdleToken(_idleDAI);

        IDLE_DAI_ADDRESS = _idleDAI;
        underlyingERC20 = _erc20;
    }


    /***
     * @dev - Stakeholder of Social Impact Bond
     * Service Provider - Institution for developing vaccines of COVID19
     * Investor
     * Evaluator
     * Government
     **/


    /***
     * @dev - Register functions
     **/     
    function registerServiceProvider() public returns (bool) {}

    function registerInvester() public returns (bool) {}

    function registerEvaluator() public returns (bool) {}

    function registerGovernment() public returns (bool) {}



    /***
     * @dev - Define Objective for saving cost (This objective become criteria for whether it judging success or not)
     *      - This function is executed by government only.
     * @param _startDate - Timestamp of starting date
     * @param _endDate - Timestamp of ending date
     **/
    function defineObjective(
        uint _serviceProviderId, 
        uint _savedCostOfObjective, 
        uint _startDate, 
        uint _endDate) public returns (bool) 
    {
        Objective storage objective = objectives[_serviceProviderId];
        objective.serviceProviderId = _serviceProviderId;
        objective.savedCostOfObjective = _savedCostOfObjective;
        objective.startDate = _startDate;
        objective.endDate = _endDate;

        emit DefineObjective(objective.serviceProviderId, 
                             objective.savedCostOfObjective, 
                             objective.startDate, 
                             objective.endDate);
    }

    /***
     * @dev - Evaluate outcome which is generated by service provider
     *      - The outcome is evaluated by evaluator
     **/
    function evaluateOutcome(uint _serviceProviderId, uint _evaluatorId, uint _savedCostOfOutcome) public returns (bool) {
        uint currentTimestamp = now;
        uint _endDateOfObjective = getObjective(_serviceProviderId).endDate;
        uint _savedCostOfObjective = getObjective(_serviceProviderId).savedCostOfObjective;

        Objective storage objective = objectives[_serviceProviderId];
        objective.evaluatorId = _evaluatorId;
        objective.savedCostOfOutcome = _savedCostOfOutcome;
        objective.isEvaluated = true;

        //@dev - Conditional branch whether objective is achieved or not
        //require (currentTimestamp > _endDateOfObjective, "CurrentTimestamp doesn't end");
        if (currentTimestamp > _endDateOfObjective) {
            if (objective.savedCostOfOutcome >= _savedCostOfObjective) {
                objective.isAchieved = true;
            }
        }

        emit EvaluateOutcome(objective.serviceProviderId, 
                             objective.evaluatorId, 
                             objective.savedCostOfOutcome, 
                             objective.isEvaluated,
                             objective.isAchieved);        
    } 


    /***
     * @dev - Collect fund with DAI.
     **/
    //function collectFund(uint _serviceProviderId , uint _investorId) public returns (bool) {}



    /***
     * @dev - Lend pooled fund(DAI) to idle.finance(idleDAI)
     **/
    function lendPooledFund(uint256 _mintAmount, uint256[] memory _clientProtocolAmounts) public returns (bool) {
        dai.approve(IDLE_DAI_ADDRESS, _mintAmount);
        idleDAI.mintIdleToken(_mintAmount, _clientProtocolAmounts);
    }
    
    /***
     * @dev - Redeem pooled fund(DAI) from idle.finance(idleDAI)
     **/
    function redeemPooledFund() public returns (bool) {}

    /***
     * @dev - Withdraw pooled fund(DAI) and distribute seed money plus interest to each investors
     **/
    function withdrawAndDistributePooledFund() public returns (bool) {

    }




    /***
     * @dev - Getter function
     **/
    function getObjective(uint _serviceProviderId) public view returns (Objective memory) {
        Objective memory objective = objectives[_serviceProviderId];
        return objective;
    }

    function balanceOfContract() public view returns (uint balanceOfContract_DAI, uint balanceOfContract_idleDAI) {
        return (dai.balanceOf(address(this)), idleDAI.balanceOf(address(this)));
    }
    
}
