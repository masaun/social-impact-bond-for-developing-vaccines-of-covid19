pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

// Library
import "../lib/DaiAddressLib.sol";

// DAI
import "./DAI/dai.sol";


/**
 * The ProxyContractFactory contract does this and that...
 */
contract ProxyContractFactory {
    address DAI_ADDRESS = DaiAddressLib.DaiAddress();

    Dai public dai;  //@dev - dai.sol

    constructor() public {
        dai = Dai(DAI_ADDRESS);
    }

    function transferDAI(address investorAddress, uint dividedAmount) returns(bool res) internal {
        dai.approve(address(this), dividedAmount);
        dai.transfer(investorAddress, dividedAmount);
    }
    
}
