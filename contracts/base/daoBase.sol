//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract daoBase {
    
    address public owner;
    
    uint public index;
    
    struct daoBaseInfo {
        string name;
        string logo;
        string des;
        address authority;
        address manage;
        address vault;
    }
    mapping(address => uint[]) userDaos;
    
    daoBaseInfo[] public array;
    
    constructor(address _owner) public{
        owner = _owner;
    }
    
    modifier onlyOnwer(){
    require(msg.sender == owner,"Invalid address");
    _;
    }
    
    function transferOwner(address to) public onlyOnwer{
        owner = to;
        
    } 
    
    function creatDao(string memory _name, string memory _logo, string memory _des) public {
        require(msg.sender != address(0), "send is not addres(0)");
        
    }
}