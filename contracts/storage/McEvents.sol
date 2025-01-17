pragma solidity ^0.5.11;

import "./McObjects.sol";

// Original Contract
import "../ProxyContractFactory.sol";
import "../ProxyGovernmentFundFactory.sol";


contract McEvents {

    event DefineObjective(
        uint objectiveId,
        ProxyContractFactory objectiveAddress,
        ProxyGovernmentFundFactory objectiveAddressForGovernmentFund,
        uint serviceProviderId,
        uint estimatedBudgetAmount,  // Estimated budget amount by the government
        uint requestedBudgetAmount,  // Requested budget amount by service providers (ask this budget for investors)
        uint savedCostOfObjective,
        uint startDate,
        uint endDate
    );
    
    event EvaluateOutcome(
        uint serviceProviderId,
        uint evaluatorId,
        uint savedCostOfOutcome,
        bool isEvaluated,
        bool isAchieved
    );

    event CreateProxyContract (
        ProxyContractFactory proxyContract
    );

    event CreateProxyGovernmentFund (
        ProxyGovernmentFundFactory proxyGovernmentFund
    );
    
    event RegisterInvester(
        uint investorId,
        address investorAddress
    );
    
    event RegisterInvestedInvestor(
        uint objectiveId, 
        uint investorId,
        address investorAddress
    );

    event DistributePooledFund(
        uint countTargetInvestors, 
        uint balanceOfObjectiveId, 
        uint dividedAmount
    );
    
    event TransferDAI(
        address spender, 
        address investorAddress, 
        uint dividedAmount
    );

    event TransferDaiFromGoverment(
        address spender, 
        address objectiveAddress, 
        uint stakeAmount
    );    

    event PayForSuccessful(
        address spender, 
        address investorAddress, 
        uint dividedAmount
    );

    event StakeFundFromGovernment(
        //address spender, 
        address objectiveAddressForGovernmentFund, 
        uint stakeAmount
    );
    


    /***
     * @dev - Example
     **/
    event Example(
        uint256 indexed Id, 
        uint256 exchangeRateCurrent,
        address msgSender,
        uint256 approvedValue    
    );

}
