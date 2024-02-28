// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MyContract} from "./MyContract.sol";

error SeedTooShort();

/// @title Coinflip 10 in a Row
/// @author Maximo Mucientes
/// @notice Contract used as part of the course Soliditd and Smart Contract development
contract Coinflip is Ownable {
    
    string public seed;
    MyContract public myContract;

    constructor(address myContractAddress) Ownable(msg.sender) {
        seed = "It is a good practice to rotate seeds often in gambling";
        myContract = MyContract(myContractAddress);
    }

    function userInput(uint8[10] calldata Guesses) external view returns(bool) {
        uint8[10] memory generatedGuesses = getFlips();

        for (uint i = 0; i < 10; i++) {
            if (Guesses[i] != generatedGuesses[i]) {
                return false;
            }
        }
        return true;
    }

    function seedRotation(string memory NewSeed) public onlyOwner {
        require(bytes(NewSeed).length >= 10, "Seed length must be 10 or more");

        // Perform rotational logic
        bytes memory seedBytes = bytes(NewSeed);
        uint256 length = seedBytes.length;
        uint256 rotations = 5; // Rotate the string 5 times
        bytes memory rotatedSeed = new bytes(length);

        for (uint256 i = 0; i < length; i++) {
            uint256 newIndex = (i + rotations) % length;
            rotatedSeed[newIndex] = seedBytes[i];
        }

        // Convert rotated bytes back to string
        seed = string(rotatedSeed);
    }

    function getFlips() public view returns(uint8[10] memory) {
        bytes memory stringInBytes = bytes(seed);
        uint256 seedLength = stringInBytes.length;
        uint8[10] memory results;

        uint interval = seedLength / 10;

        for (uint i = 0; i < 10; i++) {
            uint randomNum = uint(keccak256(abi.encodePacked(stringInBytes[i*interval], block.timestamp)));
            
            if (randomNum % 2 == 0) {
                results[i] = 1;
            } else {
                results[i] = 0;
            }
        }

        return results;
    }
}

