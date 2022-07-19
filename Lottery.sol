// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery
{
    address payable public manager;
    address payable[] public participants;
    uint public count =0;

    constructor()
    {
        manager= payable(msg.sender);//golbal variable
    }

    receive() external payable
    {
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }

    function random() view public returns(uint)
    {
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function SelectWinner() public 
    {   count++;
        require(msg.sender==manager);
        require(participants.length>3);
        uint r=random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance()-count);
        participants=new address payable[](0);
    }

    function receiveMoney() public
    {
        manager.transfer(count);
        count=0;
    }
}
