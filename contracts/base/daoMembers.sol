//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import {Set} from "../lib/TokenSet.sol";
contract daoMembers{
    using Set for Set.Address;
 address public owner;
 
 uint public voteId;
 
 mapping(address => string) public membersName;
 mapping(address => bool) public moderators;
 mapping(uint => mapping(address => bool)) public voters;
 mapping(address => uint) public joinTime;
 
    Set.Address applying;
    Set.Address members;

 
    constructor(address _owner) public {
        owner = _owner;
    }
    
    modifier onlyManager(){
        require(msg.sender == owner || moderators[msg.sender] , "you are not manager");
        _;
    }
    
}