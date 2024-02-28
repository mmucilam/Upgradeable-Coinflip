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
        bytes memory newSeedBytes = bytes(NewSeed);
        uint256 seedLength = newSeedBytes.length;

        if (seedLength < 10) {
            revert SeedTooShort();
        }
        
        seed = NewSeed;
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
