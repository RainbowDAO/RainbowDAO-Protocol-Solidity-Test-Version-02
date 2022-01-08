pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import '../interfaces/IRainbow.sol';
import '../interfaces/ICityNode.sol';

import './Type.sol';
import '../token21/RbtVote.sol';
import './DefaultTime.sol';
import '../RContractAddress.sol';
import {StructTypes} from '../libraries/StructTypes.sol';

contract Vote is RContractAddress, DefaultTime {
    
  
    RbtVote Rv = RbtVote(Cr.getContract('RbtVote'));
    
    ICityNode cn = ICityNode(Cr.getContract('CityNode'));
    
    event voteToManager(address voter,address receiver,uint amount);
    
    event voteToMsManagerEvent(address voter,address receiver,uint amount);
    
    function vote(uint256 nodeId,uint256 amount,address receiver) public {

        IRainbow Rb = IRainbow(Cr.getContract("RainBow"));
        require(Rb.inNode(msg.sender,nodeId) && Rb.verifyJoinTime(msg.sender),"no right");
        StructTypes.cityNode memory  cityNodeInfo =  cn.getCityNodInfo(nodeId);

        //当前时间过了公示期，小于投票期
        require(block.timestamp  >  Rb.getUserExpireTime(cityNodeInfo.nodeOwner) + defaultNodeExpireTime + defaultCampaignPublicity,'Unexpired');

        require(block.timestamp <  Rb.getUserExpireTime(cityNodeInfo.nodeOwner) + defaultNodeExpireTime + defaultCampaignPublicity + defaultVoteTime,'Unexpired');

        //判断此人的数量够不够

        uint vote = Rv.getUserCampaignVotes(msg.sender,cityNodeInfo.currentCampaignManagerId);

        require(amount <= vote && amount > 0,'Not enough votes');

        cn.setCampaignRecord(cityNodeInfo.currentCampaignManagerId,receiver,amount);
//        campaignRecord[cityNodeInfo.currentCampaignManagerId][receiver] += amount;

        Rv.subCampaignVotes(cityNodeInfo.currentCampaignManagerId,msg.sender,amount);

        emit voteToManager(msg.sender,receiver,amount);
    }

    //投票给多签管理
    function voteToMsManager(uint256 nodeId,uint256 amount,address receiver) public {
        address rainbow = Cr.getContract("RainBow");
        require(IRainbow(rainbow).inNode(msg.sender,nodeId)&&IRainbow(rainbow).verifyJoinTime(msg.sender),"no right");
        StructTypes.cityNode memory  cityNodeInfo =  cn.getCityNodInfo(nodeId);
        
        StructTypes.campaignMsManager[] memory cmm = cn.getCampaignMsUsers(cityNodeInfo.currentCampaignMsManagerId);

        require(cmm.length >= 15,'no enough user');
        
        

        require(block.timestamp > cn.getNodeMsManagerExpireTime(nodeId) + defaultCampaignPublicity,'It not time');

        require(block.timestamp <   cn.getNodeVoteContinueTime(nodeId) ,'Unexpired');

        require(amount > 0,'error amount');


        uint vote = Rv.getUserCampaignVotes(msg.sender,cityNodeInfo.currentCampaignManagerId);

        require(amount <= vote && amount > 0 && vote > 0,'Not enough votes');

        //         campaignMsRecord[cityNodeInfo[nodeId].currentCampaignMsManagerId][receiver] += amount;

      
        for(uint i;i< cmm.length;i++){
            if(receiver == cmm[i].campaigner){
                cn.setMsManagerTicket(cityNodeInfo.currentCampaignMsManagerId,i,amount);
//                cmm[i].tickets += amount;
            }
        }
        Rv.subCampaignVotes(cityNodeInfo.currentCampaignManagerId,msg.sender,amount);
        //         Rv.changeBlockAmount(msg.sender,amount,point);

        emit voteToMsManagerEvent(msg.sender,receiver,amount);
    }
    
    //结束多签投票（计算得票最高前12名）todo 需要某个人来操作 这个人是谁？
     function endMsManagerVote(uint nodeId) public {
         
        cityNode memory  cityNodeInfo =  cn.getCityNodInfo(nodeId);
        
        campaignMsManager[] memory cmm = cn.getCampaignMsUsers(cityNodeInfo.currentCampaignMsManagerId);
        
         require(block.timestamp >    cn.getNodeVoteContinueTime(nodeId) ,'Unexpired');
        
         // todo require sort the res
        //   _quickSort(
        //       cmm,
        //       int(0),
        //       int(cmm.length - 1)
        //   );

        cn.setNodeMsManagerExpireTime(nodeId,uint64(block.timestamp + defaultInitialMemberExpireTime));
     }
    

}
