
pragma solidity ^0.4.8;

contract EthereumLotterySystem{

	//Defining State variables
	uint public totalBet;
	uint[] public contributions;
	address public contractManager;
	address[] public participants;
	mapping(address => uint) public currentBet;

	//Constructor for the Lottery function, makes contract creator as the contractManager.
	function Lottery() public{
		contractManager = msg.sender;
	}

	// If the participant has paid more than 0.01 ether then sign them up for the Lottery.
	function enterLottery() public payable{

		// Check if the contribution from the user is less than 0.01 ether, if so abort!
		require(msg.value > 0.01 ether);

		//Add the message sender to the participants array
		uint etherValue = msg.value;
		totalBet += etherValue/1000000000000000000; //for conversion in ethers
		currentBet[msg.sender] = etherValue;

		// Add the message sender to the list of participants
		participants.push(msg.sender);

		//Add the contribution to the contributions list
		contributions.push(etherValue);
	}
}