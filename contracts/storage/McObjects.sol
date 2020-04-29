pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;


contract McObjects {

    struct Objective {
        //@dev - Define objective
        uint governmentId;
        uint savedCostOfObjective;

        //@dev - Evaluate outcome
        uint evaluatorId;
        uint savedCostOfOutcome;
        bool isEvaluated;
        bool isAchieved;
    }    




    /***
     * @dev - Example
     **/
    enum ExampleType { TypeA, TypeB, TypeC }

    struct ExampleObject {
        address addr;
        uint amount;
    }

    struct Sample {
        address addr;
        uint amount;
    }

}
