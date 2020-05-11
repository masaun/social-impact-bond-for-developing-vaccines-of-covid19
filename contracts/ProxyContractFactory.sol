pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

// Storage
import "./storage/McEvents.sol";

// Library
import "./lib/DaiAddressLib.sol";

// DAI
import "./DAI/dai.sol";


/**
 * The ProxyContractFactory contract does this and that...
 */
contract ProxyContractFactory is McEvents {
    address DAI_ADDRESS = DaiAddressLib.DaiAddress();

    Dai public dai;  //@dev - dai.sol

    constructor() public {
        dai = Dai(DAI_ADDRESS);
    }

    function transferDAI(address investorAddress, uint dividedAmount) public returns (bool) {
        address spender = msg.sender;
        dai.approve(spender, dividedAmount);
        dai.transfer(investorAddress, dividedAmount);

        emit TransferDAI(spender, investorAddress, dividedAmount);
    }
    
    function transferDaiFromGoverment(address objectiveAddress, uint stakeAmount) public returns (bool) {
        address spender = msg.sender;
        dai.approve(spender, stakeAmount);
        dai.transfer(objectiveAddress, stakeAmount);

        emit TransferDaiFromGoverment(spender, objectiveAddress, stakeAmount);
    }
}
