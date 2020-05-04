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

// Original Contract
import "./StakeholderRegistry.sol";
import "./ProxyContractFactory.sol";



/***
 * @notice - This contract is that ...
 **/
contract SocialImpactBond is OwnableOriginal(msg.sender), McStorage, McConstants {
    using SafeMath for uint;

    //@dev - current IDs
    uint currentObjectiveId = 1;

    //@dev - Token Address
    address IDLE_DAI_ADDRESS;

    Dai public dai;  //@dev - dai.sol
    IERC20 public erc20;
    IdleToken public idleDAI;

    StakeholderRegistry public stakeholderRegistry;

    constructor(address _erc20, address _idleDAI, address _stakeholderRegistry) public {
        dai = Dai(_erc20);
        erc20 = IERC20(_erc20);
        idleDAI = IdleToken(_idleDAI);
        stakeholderRegistry = StakeholderRegistry(_stakeholderRegistry);

        IDLE_DAI_ADDRESS = _idleDAI;
    }


    function createProxyContract() public returns (ProxyContractFactory _proxyContract) {
        ProxyContractFactory proxyContract = new ProxyContractFactory();
        emit CreateProxyContract(proxyContract);
        return proxyContract;
    }
    


    // function proxyContractFactory(uint256 saltNonce) public returns (address proxyContractAddress) {
    //     //@dev - Create new contract address for new objective
    //     //bytes contractBytecode = hex"";
    //     bytes memory bytecode = type(this).creationCode;
    //     bytes32 salt = keccak256(abi.encode(msg.sender, _saltNonce));
    //     address proxyContractAddress;
    //     assembly {
    //       proxyContractAddress := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
    //     }
    // }
    


    /***
     * @dev - Define Objective for saving cost (This objective become criteria for whether it judging success or not)
     *      - This function is executed by government only.
     * @param _startDate - Timestamp of starting date
     * @param _endDate - Timestamp of ending date
     **/
    function defineObjective(
        uint _saltNonce,
        uint _serviceProviderId, 
        uint _savedCostOfObjective, 
        uint _startDate, 
        uint _endDate) public returns (bool) 
    {
        //@dev - Create new contract address for new objective
        createProxyContract();
        //address _proxyContractAddress = createProxyContract();
        //address _proxyContractAddress = proxyContractFactory(_saltNonce);

        //@dev - Create and save new objective
        Objective storage objective = objectives[currentObjectiveId];
        objective.objectiveId = currentObjectiveId;
        objective.serviceProviderId = _serviceProviderId;
        objective.savedCostOfObjective = _savedCostOfObjective;
        objective.startDate = _startDate;
        objective.endDate = _endDate;

        emit DefineObjective(objective.objectiveId,
                             objective.serviceProviderId, 
                             objective.savedCostOfObjective, 
                             objective.startDate, 
                             objective.endDate);

        currentObjectiveId++;
    }

    /***
     * @dev - Evaluate outcome which is generated by service provider
     *      - The outcome is evaluated by evaluator
     **/
    function evaluateOutcome(uint _objectiveId, uint _serviceProviderId, uint _evaluatorId, uint _savedCostOfOutcome) public returns (bool) {
        uint currentTimestamp = now;
        uint _endDateOfObjective = getObjective(_serviceProviderId).endDate;
        uint _savedCostOfObjective = getObjective(_serviceProviderId).savedCostOfObjective;

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
    function distributePooledFund(uint _objectiveId,uint _serviceProviderId) public returns (bool) {
        Objective memory objective = objectives[_objectiveId];
        bool _isAchieved = objective.isAchieved;

        //@dev - Only investors who invested service providers achieved their objective can receive returned money (principal amounts plus interest amounts)
        for (uint i=1; i < currentObjectiveId; i++) {
            Objective memory objective = objectives[i];
        }
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


    /***
     * @dev - Get IDs
     **/
    function getCurrentObjectiveId() public view returns (uint _currentObjectiveId) {
        return currentObjectiveId;
    }
    
}
