pragma solidity 0.8.10;

contract HelloWorld {
    string myString;

    function hello() public view returns (string memory) {
        
        return myString;
    }
}