pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

// Original Contract
import "../ProxyContractFactory.sol";


contract McObjects {

    struct Objective {
        //@dev - Define objective
        uint objectiveId;
        ProxyContractFactory objectiveAddress;
        uint serviceProviderId;
        uint estimatedBudgetAmount;  // Estimated budget amount by the government
        uint requestedBudgetAmount;  // Requested budget amount by service providers (ask this budget for investors)
        uint savedCostOfObjective;
        uint startDate;
        uint endDate;

        //@dev - Evaluate outcome
        uint evaluatorId;
        uint savedCostOfOutcome;
        bool isEvaluated;
        bool isAchieved;
    }

    struct InvestorOfObjective {
        uint objectiveId;
        uint investorId;
        address investorAddress;
    }

    struct Investor {
        uint investorId;
        address investorAddress;           
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
