pragma solidity 0.8.11;

contract MyNewContract {

    mapping (address => uint) private balances;

    function deposit() external payable{ balances[msg.sender] += msg.value;}

    function withdraw(address payable addr, uint amount) public payable{

        require(balances[addr]>=amount, "solde insuffisant");
        (bool sent, bytes memory data) = addr.call{value:amount}("");
        require(sent, "Error couldn\'t withdraw!");
		balances[msg.sender] -= amount;

    }

    function solde() public view returns(uint){
        return address(this).balance;
    }


}