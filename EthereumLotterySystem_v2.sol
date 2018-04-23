
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
		require(msg.value > 0.01 ether);
		//Add the message sender to the participants array
		uint etherValue = msg.value;
		totalBet += etherValue/1000000000000000000; //for conversion in ethers
		currentBet[msg.sender] = etherValue;
		participants.push(msg.sender);
		contributions.push(etherValue);
	}

	//Pseudo random number generator 
	function randomGenerator() private view returns (uint){
		//Returns an unsigned integer, which is a keccak256 hash of the current block difficulty, current time and the participants in the Lottery.
		return uint(keccak256(block.difficulty, now, participants));
	}

	// Function that chooses an index between 0 to participants' array length which can be used to transfer the totalBet into the winners' account address.
	function selectWinner() public restricted{
		uint winIndex = randomGenerator() % participants.length;
		//this.balance represents the current balance of the contract.
		participants[winIndex].transfer(this.balance);

		//Resets the number of participants in the Lottery.
		participants = new address[](0);

	}

	// modifier that will allow a function to execute only if the request is sent by the contract manager.
	modifier restricted(){
		require(msg.sender == contractManager);
		_;
	}
}