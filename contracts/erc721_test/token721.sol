pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract token721 is ERC721{
    address public owner;
    
    constructor(address manager) public ERC721("HKG","HKG"){
     owner = manager;
     
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner, "");
        _;
    }
    

    function mint_721(address user, uint256 tokenid) public onlyOwner {
        _safeMint(user,tokenid); 
    }
}
