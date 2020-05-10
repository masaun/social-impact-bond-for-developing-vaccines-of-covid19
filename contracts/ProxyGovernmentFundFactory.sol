pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

// Storage
import "./storage/McEvents.sol";

// Library
import "./lib/DaiAddressLib.sol";

// DAI
import "./DAI/dai.sol";


/**
 * The ProxyContractForGovernmentFactory contract does this and that...
 */
contract ProxyGovernmentFundFactory {
    address DAI_ADDRESS = DaiAddressLib.DaiAddress();

    Dai public dai;  //@dev - dai.sol

    constructor() public {
        dai = Dai(DAI_ADDRESS);
    }

    function transferDAI(address investorAddress, uint dividedAmount) public returns (bool) {
        address spender = msg.sender;
        dai.approve(spender, dividedAmount);
        dai.transfer(investorAddress, dividedAmount);

        //emit TransferDAI(spender, investorAddress, dividedAmount);
    }
    
}
