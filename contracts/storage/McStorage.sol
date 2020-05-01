pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

import "./McObjects.sol";
import "./McEvents.sol";


// shared storage
contract McStorage is McObjects, McEvents {

    ///////////////////////////////////
    // @dev - Define as memory
    ///////////////////////////////////
    address[] exampleGroups;

    
    //////////////////////////////////
    // @dev - Define as storage
    ///////////////////////////////////
    mapping (uint => Objective) objectives;

    mapping (uint => Investor) investors;
    


    ExampleObject[] public exampleObjects;

    mapping (uint256 => Sample) samples;

}
