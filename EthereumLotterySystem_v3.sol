
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

	// Function to return the array of current participants in the Lottery.
	function currentParticipants() public view returns (address[]){
		return participants;
	}

	// Function to return current balance of all the participants.
	function contributions() public view returns (uint[]){
		return contributions;
	}

	// Function to cancel the current Lottery and return the pooled amount back to the participants.
	function cancelLottery() public restricted{
		//Looping in all participants to return their contribution in the Lottery kitty.
		for(uint i=0; i < participants.length; i++){

			//Transfer the pooled in amount back to the participant
			participants[i].transfer(currentBet[participants[i]]);
			currentBet[participants[i]] = 0;
		}
		contributions = new uint[](0);
		participants = new address[](0);
	}

}