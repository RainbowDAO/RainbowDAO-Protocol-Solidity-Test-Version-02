pragma solidity ^0.8.0;

contract daoRole{
    address public _manager;
    mapping(address => mapping( uint32 => address)) public accountDao;

    constructor(address manager ) public {
        _manager = manager;
    }
    modifier onlyManager(){
        require(msg.sender == _manager);
        _;
    } 
function transferManager(address to ) public onlyManager {
_manager = to;
}
function walletOrMultiOrDao(address  role , uint32 roleNum,  address daoAddr) public onlyManager{
accountDao[role][roleNum] = daoAddr;
}
}