pragma solidity 0.8.10;

contract Bank {
    mapping (address => uint) private _balances;

    function deposite(uint _amout) public{
        _balances[msg.sender] += _amout;
    }

    function transfer(address _recipient, uint _amount) internal {
        _balances[_recipient] += _amount;
        _balances[msg.sender] += _amount;
    }

    function balanceOf(address _address) public view returns (uint) {
        return _balances[_address];
    }
}