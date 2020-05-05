pragma solidity ^0.5.11;

import "./McObjects.sol";

// Original Contract
import "../ProxyContractFactory.sol";


contract McEvents {

    event DefineObjective(
        uint objectiveId,
        ProxyContractFactory objectiveAddress,
        uint serviceProviderId,
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
        //address proxyContractAddress
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
