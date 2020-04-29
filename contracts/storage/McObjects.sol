pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;


contract McObjects {

    struct Objective {
        uint governmentId;
        uint savedCost;
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
