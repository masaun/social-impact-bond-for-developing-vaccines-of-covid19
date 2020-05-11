pragma solidity >=0.4.21 <0.6.0;


library IdleDaiAddressLib {
    /**
     * @dev returns the address used within the protocol to identify DAI
     * @return the address assigned to DAI
     */
    function IdleDaiAddress() internal pure returns (address) {
        return 0x199e7c55B44fFBD2934bFC3bDeE05F6EC2b547CF;  // IdleDAI address on Kovan
    }
}
