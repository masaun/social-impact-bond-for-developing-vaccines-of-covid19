pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

// Library
import "./lib/DaiAddressLib.sol";

// DAI
import "./DAI/dai.sol";


/**
 * The ProxyContractForGovernmentFactory contract does this and that...
 */
contract ProxyContractForGovernmentFundFactory {
    address DAI_ADDRESS = DaiAddressLib.DaiAddress();

    Dai public dai;  //@dev - dai.sol

    constructor() public {
        dai = Dai(DAI_ADDRESS);
    }

    function transferDAI(address investorAddress, uint dividedAmount) public returns (address _spender, address _investorAddress, uint _dividedAmount) {
        address spender = msg.sender;
        dai.approve(spender, dividedAmount);
        dai.transfer(investorAddress, dividedAmount);

        return (spender, investorAddress, dividedAmount);
    }
    
}
