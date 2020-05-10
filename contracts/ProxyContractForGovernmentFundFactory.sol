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

    function transferDAI(address objectiveAddressForGovernmentFund, uint stakeAmount) public returns (address _spender, address _objectiveAddressForGovernmentFund, uint _stakeAmount) {
        address spender = objectiveAddressForGovernmentFund;  //@dev - Spender is destination contract address
        dai.approve(spender, stakeAmount);
        dai.transfer(objectiveAddressForGovernmentFund, stakeAmount);

        return (spender, objectiveAddressForGovernmentFund, stakeAmount);
    }
    
}
