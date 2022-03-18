pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
// import {StructTypes} from '../lib/StructTypes.sol';
import '../routeManage/routeManage.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '../base/daoMembers.sol';
import '../interface/IdaoManageCore.sol';

contract Vote {
    uint index;
    address public _manager;
    address public memberAddr;
   event voteToManager(address voter,address receiver,uint amount);
   event voteToMsManagerEvent(address voter,address receiver,uint amount);
   struct onePersonOneVote{
       address user;
       uint userId;
   }

    mapping(address => uint) public voteWay;
    mapping(address => uint) public userVoteAmount;
    mapping(address => uint) public userVoteAmountOne;
    mapping(uint => onePersonOneVote) public voterList;
    
    constructor(address manager,address daoMemberAddr) public{
        _manager = manager;
    }
    
    modifier onlyManager{
        require(msg.sender  == _manager);
        _;
    }

    function transferManager(address to) public onlyManager {
        _manager = to;
    }
    
    function choseVoteWay(uint way , address daoAddr) public onlyManager{
        require(daoAddr != address(0),"is not a dao");
        voteWay[daoAddr] = way;
    }
   
   function getVote(address dao ,address token) public{
    
       if (voteWay[dao] == 1){
            userVoteAmount[msg.sender] = IERC20(token).balanceOf(msg.sender);
       }
       if (voteWay[dao] == 2){
            if(IdaoManage(memberAddr).checkUserAllow()){
            index++;
                onePersonOneVote memory c =  onePersonOneVote({
                    user:msg.sender,
                    userId:index
                });
                
            }
       }
   }
   
   
   function vote(uint256 nodeId,uint256 amount,address receiver) public {
    
   }

   function voteToMsManager(uint256 nodeId,uint256 amount,address receiver) public {
    
   }
    
   function endMsManagerVote(uint nodeId) public {
         
     // require(block.timestamp >  ,'Unexpired');
        
   }
    

}
