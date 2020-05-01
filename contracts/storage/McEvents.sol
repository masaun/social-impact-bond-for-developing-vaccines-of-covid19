pragma solidity ^0.5.11;

import "./McObjects.sol";


contract McEvents {

    event DefineObjective(
        uint objectiveId,
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
