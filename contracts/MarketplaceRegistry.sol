pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

// Storage
import "./storage/McStorage.sol";
import "./storage/McConstants.sol";

// DAI
import "./DAI/dai.sol";


/***
 * @notice - This contract is that ...
 **/
contract MarketplaceRegistry is Ownable, McStorage, McConstants {
    using SafeMath for uint;

    address underlyingERC20;

    Dai public dai;  //@dev - dai.sol
    IERC20 public erc20;

    constructor(address _erc20) public {
        dai = Dai(_erc20);
        erc20 = IERC20(_erc20);

        underlyingERC20 = _erc20;
    }

    function testFunc(uint256 _mintAmount) public returns (bool, uint256 _approvedValue) {
        uint256 _id = 1;
        uint256 _exchangeRateCurrent = McConstants.onePercent;

        address _to = 0x8Fc9d07b1B9542A71C4ba1702Cd230E160af6EB3;

        address _owner = address(this); //@dev - contract address which do delegate call
        //address _owner = msg.sender;
        address _spender = 0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa;    // DAI address on Rinkeby (borrow from Compound)

        //@dev - Allow _spender to withdraw from your account, multiple times, up to the _value amount. 
        erc20.approve(_spender, _mintAmount.mul(10**18));
            
        //@dev - Returns the amount which _spender is still allowed to withdraw from _owner
        uint256 _approvedValue = erc20.allowance(_owner, _spender);
        
        //@dev - Expected transferred value is 1.05 DAI（= 1050000000000000000 Wei）
        erc20.transfer(_to, _mintAmount.mul(10**18).div(10**2));        

        emit Example(_id, _exchangeRateCurrent, msg.sender, _approvedValue);

        return (McConstants.CONFIRMED, _approvedValue);
    }

    function balanceOfCurrentAccount(address _currentAccount) public view returns (uint256 balanceOfCurrentAccount) {
        return erc20.balanceOf(_currentAccount);
    }
    

    function transferDAIFromUserToContract(uint256 _mintAmount) public returns (bool) {
        address _from = address(this);
        address _to = 0x8Fc9d07b1B9542A71C4ba1702Cd230E160af6EB3;

        erc20.approve(underlyingERC20, _mintAmount.mul(10**18));
        uint256 _allowanceAmount = erc20.allowance(address(this), underlyingERC20);
        //uint256 _allowanceAmount = erc20.allowance(msg.sender, address(this));
        erc20.transferFrom(_from, _to, _mintAmount.mul(10**18).div(10**2));

        emit _TransferFrom(_from, _to, _mintAmount.mul(10**18), _allowanceAmount);
    }
    
}
