pragma solidity 0.8.11;

contract MyFirstContract {

    // mapping(uint => int)public map;

    // function setx(uint key, int value)public{
    //     map[key] = value;
    // }
    address public lastSender;

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function recieve() external payable{
        lastSender = msg.sender; 
    }

    function pay(address payable addr) public payable{
        (bool sent, bytes memory data) = addr.call{value: 1 ether}("");
        require(sent, "Error sending eth.");
    }

}



