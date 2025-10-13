// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
contract Migration{
    address public owner;

    uint public last_Completed_Migration;


    modifier restricted() {
        require(msg.sender == owner, "Only Restricted to the Contract Owner");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }
    

    function setCompleted(uint completed) public restricted {
        last_Completed_Migration = completed;
    }

    function upgrade(address new_address) public restricted {
        Migration upgraded = Migration(new_address);
        upgraded.setCompleted(last_Completed_Migration);
    }
}