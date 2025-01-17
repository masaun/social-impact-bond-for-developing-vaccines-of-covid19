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

// DateTime
import "./lib/BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeContract.sol";

// Original Contract
import "./StakeholderRegistry.sol";
import "./ProxyContractFactory.sol";
import "./ProxyGovernmentFundFactory.sol";


/***
 * @notice - This contract is that ...
 **/
contract SocialImpactBond is OwnableOriginal(msg.sender), McStorage, McConstants {
    using SafeMath for uint;

    //@dev - current IDs
    uint public currentObjectiveId = 1;

    //@dev - Token Address
    address IDLE_DAI_ADDRESS;

    Dai public dai;  //@dev - dai.sol
    IERC20 public erc20;
    IdleToken public idleDAI;
    BokkyPooBahsDateTimeContract public bokkyPooBahsDateTimeContract;

    StakeholderRegistry public stakeholderRegistry;
    ProxyContractFactory public proxyContractFactory;
    ProxyGovernmentFundFactory public proxyGovernmentFundFactory;


    constructor(address _erc20, address _idleDAI, address _stakeholderRegistry, address _bokkyPooBahsDateTimeContract) public {
        dai = Dai(_erc20);
        erc20 = IERC20(_erc20);
        idleDAI = IdleToken(_idleDAI);
        stakeholderRegistry = StakeholderRegistry(_stakeholderRegistry);
        bokkyPooBahsDateTimeContract = BokkyPooBahsDateTimeContract(_bokkyPooBahsDateTimeContract);

        IDLE_DAI_ADDRESS = _idleDAI;
    }

    /***
     * @dev - Created ProxyContract works as a wallet of each objective for working capital
     **/
    function createProxyContract() public returns (ProxyContractFactory _proxyContract) {
        ProxyContractFactory proxyContract = new ProxyContractFactory();
        emit CreateProxyContract(proxyContract);
        return proxyContract;
    }

    /***
     * @dev - Created ProxyContractForGovernmentFund works as a wallet of each objective for paying for successful
     **/
    function createProxyGovernmentFund() public returns (ProxyGovernmentFundFactory _proxyGovernmentFund) {
        ProxyGovernmentFundFactory proxyGovernmentFund = new ProxyGovernmentFundFactory();
        emit CreateProxyGovernmentFund(proxyGovernmentFund);
        return proxyGovernmentFund;
    }

    

    /***
     * @dev - Define Objective for saving cost (This objective become criteria for whether it judging success or not)
     *      - This function is executed by government only.
     **/
    function defineObjective(
        uint _serviceProviderId, 
        uint _estimatedBudgetAmount,  // Estimated budget amount by the government
        uint _requestedBudgetAmount,  // Requested budget amount by service providers (ask this budget for investors)
        //uint _savedCostOfObjective,
        uint _startDateYear,
        uint _startDateMonth,
        uint _startDateDay,
        uint _endDateYear,
        uint _endDateMonth,
        uint _endDateDay) public returns (bool) 
    {
        //@dev - Convert dateTime from date(YYYY/MM/DD) to timestamp
        uint _startDate = bokkyPooBahsDateTimeContract.timestampFromDate(_startDateYear, _startDateMonth, _startDateDay);
        uint _endDate = bokkyPooBahsDateTimeContract.timestampFromDate(_endDateYear, _endDateMonth, _endDateDay);

        //@dev - Create new contract address for new objective
        ProxyContractFactory _proxyContractAddress = createProxyContract();
        ProxyGovernmentFundFactory _proxyGovernmentFundAddress = createProxyGovernmentFund();

        //@dev - Calculate expected saving cost of objective
        uint _savedCostOfObjective = _estimatedBudgetAmount.sub(_requestedBudgetAmount);

        //@dev - Create and save new objective
        Objective storage objective = objectives[currentObjectiveId];
        objective.objectiveId = currentObjectiveId;
        objective.objectiveAddress = _proxyContractAddress;
        objective.objectiveAddressForGovernmentFund = _proxyGovernmentFundAddress;
        objective.serviceProviderId = _serviceProviderId;
        objective.estimatedBudgetAmount = _estimatedBudgetAmount;
        objective.requestedBudgetAmount = _requestedBudgetAmount;
        objective.savedCostOfObjective = _savedCostOfObjective;
        objective.startDate = _startDate;
        objective.endDate = _endDate;

        emit DefineObjective(objective.objectiveId,
                             objective.objectiveAddress,
                             objective.objectiveAddressForGovernmentFund,
                             objective.serviceProviderId, 
                             objective.estimatedBudgetAmount,
                             objective.requestedBudgetAmount,
                             objective.savedCostOfObjective, 
                             objective.startDate, 
                             objective.endDate);

        currentObjectiveId++;
    }

    function registerInvestedInvestor(uint _objectiveId, uint _investorId, address _investorAddress) public returns (bool) {
        InvestorOfObjective storage investorOfObjective = investorOfObjectives[_investorId];
        investorOfObjective.objectiveId = _objectiveId;
        investorOfObjective.investorId = _investorId;
        investorOfObjective.investorAddress = _investorAddress;
        emit RegisterInvestedInvestor(investorOfObjective.objectiveId, 
                                      investorOfObjective.investorId, 
                                      investorOfObjective.investorAddress);
    }
    

    /***
     * @dev - Evaluate outcome which is generated by service provider
     *      - The outcome is evaluated by evaluator
     **/
    function evaluateOutcome(uint _objectiveId, uint _evaluatorId, uint _savedCostOfOutcome) public returns (bool) {
        uint currentTimestamp = now;
        uint _endDateOfObjective = getObjective(_objectiveId).endDate;
        uint _savedCostOfObjective = getObjective(_objectiveId).savedCostOfObjective;

        Objective storage objective = objectives[_objectiveId];
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
     * @dev - Distribute seed money plus interest to each investors (from pooled fund(DAI))
     **/
    function distributePooledFund(uint _objectiveId) public returns (bool) {
        Objective memory objective = objectives[_objectiveId];
        bool _isAchieved = objective.isAchieved;
        //address _objectiveAddress = address(objective.objectiveAddress);
        address _objectiveAddressForGovernmentFund = address(objective.objectiveAddressForGovernmentFund);
        //proxyContractFactory = ProxyContractFactory(_objectiveAddress);
        proxyGovernmentFundFactory = ProxyGovernmentFundFactory(_objectiveAddressForGovernmentFund);

        uint _countTargetInvestors = countTargetInvestors(_objectiveId);
        uint balanceOfObjective = balanceOfObjective(_objectiveId);
        uint dividedAmount = balanceOfObjective.div(_countTargetInvestors);

        //@dev - Only investors who invested for achived objective can receive returned money (principal amounts plus interest amounts)
        if (_isAchieved == true) {
            uint _currentInvestorId = stakeholderRegistry.getCurrentInvestorId();
            for (uint i=1; i <= _currentInvestorId; i++) {
                InvestorOfObjective memory investorOfObjective = investorOfObjectives[i];
                if (investorOfObjective.objectiveId == _objectiveId) {
                    //@dev - Distribute amount (which are divided by number of investors who invested achieved objective)
                    address _investorAddress = address(investorOfObjective.investorAddress);
                    //proxyContractFactory.transferDAI(_investorAddress, dividedAmount);
                    proxyGovernmentFundFactory.transferDAI(_investorAddress, dividedAmount);
                }
            }
        }

        emit DistributePooledFund(_countTargetInvestors, balanceOfObjective, dividedAmount);
    }

    function countTargetInvestors(uint _objectiveId) public view returns (uint _countTargetInvestors) {
        Objective memory objective = objectives[_objectiveId];
        bool _isAchieved = objective.isAchieved;

        //@dev - Count target investors
        uint _countTargetInvestors;
        if (_isAchieved == true) {
            uint _currentInvestorId = stakeholderRegistry.getCurrentInvestorId();
            for (uint i=1; i <= _currentInvestorId; i++) {
                InvestorOfObjective memory investorOfObjective = investorOfObjectives[i];
                uint investorOfObjectiveId = investorOfObjective.objectiveId;
                if (investorOfObjectiveId == _objectiveId) {
                    _countTargetInvestors++;
                }
            }
        }

        return _countTargetInvestors;
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


    /***
     * @dev - Getter function
     **/
    function getObjective(uint _objectiveId) public view returns (Objective memory) {
        Objective memory objective = objectives[_objectiveId];
        return objective;
    }

    function balanceOfContract() public view returns (uint balanceOfContract_DAI, uint balanceOfContract_idleDAI) {
        return (dai.balanceOf(address(this)), idleDAI.balanceOf(address(this)));
    }

    function balanceOfObjective(uint _objectiveId) public view returns (uint balanceOfObjective_DAI) {
        Objective memory objective = objectives[_objectiveId];
        uint _balanceOfObjective = dai.balanceOf(address(objective.objectiveAddress));
        return _balanceOfObjective;
    }
    


    /***
     * @dev - Get IDs
     **/
    function getCurrentObjectiveId() public view returns (uint _currentObjectiveId) {
        return currentObjectiveId;
    }
    
    
}
