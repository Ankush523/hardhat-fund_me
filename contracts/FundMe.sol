//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
import "./PriceConverter.sol";

contract FundMe
{   
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 * 1e18;
    // want to be able to set a minimum fund amount

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable i_owner;

     
    constructor()
    {
        i_owner = msg.sender;
    }


    function fund() public payable {

        //how do we send eth to this contract
        require(msg.value.getConversionRate() > MINIMUM_USD, "Didn't send enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }


    function withdraw() public onlyOwner{

        for(uint256 funderIndex = 0; funderIndex < funders.length ; funderIndex++)
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        //withdraw the funds in 3 different ways
        //1)transfer

        // payable(msg.sender.transfer(address(this).balance));


        // //2)send

        // bool success = payable(msg.sender.send(address(this).balance));
        // require(success,"Send failed"); 


        //3)call

        (bool callSuccess, ) = payable(msg.sender).call{value : address(this).balance}("");
        require(callSuccess, "Call failed"); 


    }


    modifier onlyOwner{

        require(msg.sender == i_owner, "Sender is not owner");
        _;
    }

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }
}