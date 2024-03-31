// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 < 0.9.0;

contract lottery
{
    address public manager;
    address payable[] public people;

    constructor()
    {
        manager=msg.sender;
    }

    receive() external payable
    {
        require(msg.value==1 ether);
        people.push(payable(msg.sender));
    }

    function checkbalance() public view returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }

    function random() public view returns(uint)
    {
        return uint((keccak256(abi.encodePacked(block.prevrandao,block.timestamp))));
    }

    function selectwinner() public
    {
        require(msg.sender==manager);
        require(people.length>=3);
        uint r=random();
        uint index =r%people.length;
        address payable winner;
        winner=people[index];
        winner.transfer(checkbalance());
        people=new address payable[](0);

    }
}