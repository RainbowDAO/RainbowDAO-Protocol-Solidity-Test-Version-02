pragma solidity ^0.8.0;


contract Basic{
    address public owner;
    address public erc20Factory;
    uint public index;
    
    struct DaoInfo{
        string name;
        string logo;
        string des;
        address authority;
        address manage;
        address vault;
    }
    mapping(address => uint[]) public userDaos;
    DaoInfo[] public array;
    
    modifier onlyOnwer(){
        require(msg.sender == owner, "only owner");
        _;
    }
    
    function creatDao(string memory _name,string memory _logo,string memory _des,address _token, uint _support) external virtual {
        require(msg.sender != address(0), "Invalid address");
        address _manage = address(new DaoManage(msg.sender,address(this),_name,_logo,_des,_support));
        address _auth = address(new Authority(msg.sender,_manage));
        address _vault = address(new Vault(msg.sender,address(this),_manage, _auth));
        
        DaoInfo memory addr = DaoInfo({
            name: _name,
            logo: _logo,
            des: _des,
            authority: _auth,
            manage: _manage,
            vault: _vault
        });
        
        array.push(addr);
        userDaos[msg.sender].push(index);
        index++;
        IDaoManage(_manage).init(_auth,_vault);
        IVault(_vault).addToken(_token);
    }
    
    function getArrayLength() public view returns(uint){
        return array.length;
    }
    
    function getDaoInfo(uint index) public view returns(DaoInfo memory){
        return array[index];
    }
    
    // function _init_contracts(string memory _name,string memory _logo, string memory _des) internal {
        
    // }
    
    function getOwnedDaos() public view returns(uint[] memory){
        return userDaos[msg.sender];
    }
}