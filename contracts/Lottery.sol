// SPDX-License-Identifier: MIT

pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    function Lottery() public {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether);
        players.push(msg.sender);
    }

    function random() private view returns (uint256) {
        // sha3 is a global function provided by solidity
        // keccak256 is sort of = sha3
        // Current Block Difficulty + Current Time + Address
        return uint256(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public restricted {
        // Force that only the manager can call out pick winner
        // require(msg.sender == manager);

        uint256 index = random() % players.length;

        // transfer function is a method of address class
        // transfer(1) sends 1 wei to the address
        players[index].transfer(this.balance);

        // clear out the players array
        // address[] => dynamic array and (0) specifies the length zero
        // if we specify any default length like (5) then empty address is saved
        // initially => 0x0000
        players = new address[](0);
    }

    // Function Modifier
    modifier restricted() {
        require(msg.sender == manager);
        // imagine _ as a target where all the func code,
        // having the modifier as restricted, is pasted
        _;
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }
}
