//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "../daoManage/DaoManage.sol";

contract daoBase {
    
    address public owner;
    address public auth;
    address public vault;
    address public name;
    address public logo;
    address public des;
    
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
    mapping(string => address) daoNameAddress;
    
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
    
    function creatDao(string memory name, string memory logo, string memory des, address auth, address vault) public returns(address){
        require(msg.sender != address(0), "send is not addres(0)");
        address daoAddress = address(new DaoManage(msg.sender, name, logo, des,  auth,  vault));
        // newDao = daoAddress;
        daoNameAddress[name] = daoAddress;
        return daoAddress;
        // return address(0);
        
    }
}