// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.6;

contract Ballot{
  struct vote {
      address voteraddress;
      bool choise;
  }


  struct voter{
    string votername;
    bool voted;
  }


  uint private countresult=0;
  uint public finalresult=0;
  uint public totalvoter=0;
  uint public totalvote=0;

  address public ballotofficialaddress;
  string public ballotofficialname;
  string public proposal;

  mapping (uint => vote) private votes;
  mapping (address =>voter)public voterregister;

  enum State {created,voting,ended}
  State public state;

  modifier condition(bool _condition)
  {
    require(_condition);
    _;
  }


  modifier onlyofficial()
  {
    require(msg.sender==ballotofficialaddress);
    _;
  }


  modifier instate(State _state){
    require(state==_state);
    _;
  }


 constructor(string memory _ballotofficialname,string memory _proposol)  {
   ballotofficialaddress=msg.sender;
   ballotofficialname=_ballotofficialname;
   proposal=_proposol;
   state=State.created;

 }


  function addvoter(address _voteraddress,string memory _votername) public 
  
  {
   voter memory v;
   v.votername=_votername;
   v.voted=false;
   voterregister[_voteraddress]=v;
   totalvoter++;
  }


  function startvote() public  
  instate(State.created)
  onlyofficial
  {
    state=State.voting;
  }


  function dovote(bool _choise) public 
  instate(State.voting)
  onlyofficial
  returns  (bool voted)
  {
    bool isfound=false;
    if(bytes(voterregister[msg.sender].votername).length !=0 && voterregister[msg.sender].voted==false)
    {
        voterregister[msg.sender].voted=true;
        vote memory v;
        v.voteraddress=msg.sender;
        v.choise=_choise;
        if(_choise)
        {
          countresult++;
        }
        votes[totalvote]=v;
        totalvote++;
        isfound=true;
    }
    return isfound;
  }
  function endvote() public
  instate(State.voting)
  onlyofficial
  {
    state=State.ended;
    finalresult=countresult;
  }
  
}





















