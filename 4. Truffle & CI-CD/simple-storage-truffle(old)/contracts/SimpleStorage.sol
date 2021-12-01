pragma solidity 0.8.10;
 
contract SimpleStorage {
    uint data;
 
   function set(uint x) public {
       data = x;
   }
 
   function get() public view returns (uint) {
       return data;
   }
}
