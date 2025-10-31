// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Lottery {
    address[] public players;
    address public lastWinner;
    
    // Minimum entry: 0.00000001 ETH (10 wei)
    uint256 public constant MIN_ENTRY = 10 wei;

    // Enter lottery if ETH >= 10 wei
    function enter() public payable {
        require(msg.value >= MIN_ENTRY, "Min 0.00000001 ETH");
        players.push(msg.sender);
    }

    // Pick winner anytime (no time limit)
    function pickWinner() public {
        require(players.length > 0, "No players");

        uint256 index = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.prevrandao, players.length)
            )
        ) % players.length;

        address winner = players[index];
        lastWinner = winner;

        payable(winner).transfer(address(this).balance);
        delete players; // Reset
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}
