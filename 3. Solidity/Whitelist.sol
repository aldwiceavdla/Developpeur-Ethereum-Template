pragma solidity 0.8.10;

contract Whitelist {
    mapping (address => bool) whitelist;

    struct Person {
        string name;
        uint age;
    }

    Person[] public persons;

    function addPerson(string memory _name, uint _age) public {
        Person memory person;
        person.name = _name;
        person.age = _age;
        
        // ou bien :
        // Person memory person = Person(_name, _age);

        persons.push(person);
    }

    function removePerson() public {
        persons.pop();
    }

    event Authorized(address _address);


    function authorize(address _address) public {
        whitelist[_address] = true;
        emit Authorized(_address);
    }
}