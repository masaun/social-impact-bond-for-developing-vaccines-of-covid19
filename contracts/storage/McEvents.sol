pragma solidity ^0.5.11;

import "./McObjects.sol";


contract McEvents {

    event DefineObjective(
        uint serviceProviderId,
        uint savedCostOfObjective
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
    event _TransferFrom(
        address from,
        address to,
        uint256 transferredAmount,
        uint256 allowanceAmount
    );


    event Example(
        uint256 indexed Id, 
        uint256 exchangeRateCurrent,
        address msgSender,
        uint256 approvedValue    
    );

}
