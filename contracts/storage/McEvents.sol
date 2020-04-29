pragma solidity ^0.5.11;

import "./McObjects.sol";


contract McEvents {

    event DefineObjective(
        uint governmentId,
        uint savedCost
    );
    
    event EvaluateOutcome(
        uint governmentId,
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
