// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library SillyStringUtils {
    struct Haiku {
        string line1;
        string line2;
        string line3;
    }
    
    function shruggie(string memory _input) internal pure returns (string memory) {
        return string.concat(_input, unicode" 🤷");
    }
}

contract ImportsExercise {
    using SillyStringUtils for string;
    
    SillyStringUtils.Haiku public haiku;
    
    function saveHaiku(
        string calldata _line1, 
        string calldata _line2, 
        string calldata _line3
    ) external {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }
    
    function getHaiku() external view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }
    
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory modifiedHaiku = SillyStringUtils.Haiku({
            line1: haiku.line1,
            line2: haiku.line2,
            line3: SillyStringUtils.shruggie(haiku.line3)
        });
        
        return modifiedHaiku;
    }
}