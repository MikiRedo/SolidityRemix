// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.1/token/ERC1155/ERC1155.sol";
//import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";

contract MyToken is ERC1155 {
    uint public constant totalSupply = 4;  //total supply always 4 exactly replicas
    address public owner = msg.sender;
    mapping (address => bool) private _owners;

    //Fake addresses of the owners (the family)
    address constant MomsWallet = 0x1111111111111111111111111111111111111111;
    address constant DadsWallet = 0x2222222222222222222222222222222222222222;
    address constant BrosWallet = 0x3333333333333333333333333333333333333333;
    address constant MyWallet = 0x4444444444444444444444444444444444444444;

    event TokensWereMinted();
    event OwnershipGranted(address indexed newOwner);

    //error OnlyOwners(address _owner, address caller);

    constructor() ERC1155("") {
        _mint(MomsWallet, 1, 1, "One for the mother");
        _mint(DadsWallet, 2, 1, "One for the father");
        _mint(BrosWallet, 3, 1, "One for the brother");
        _mint(MyWallet, 4, 1, "One for myself");
        emit TokensWereMinted();
    }

    modifier OnlyOwnersAllowed(){

        require(    //the conditions to be true and then a string in case is false
                msg.sender == MomsWallet ||
                msg.sender == DadsWallet ||
                msg.sender == BrosWallet ||
                msg.sender == MyWallet,
                "Youre not the owner"
        );
        _;
    }

    //function to add the family as a owner of the SC
    function FamilyIsContractOwner(address newOwner) public OnlyOwnersAllowed {
        if(
            newOwner == MomsWallet || 
            newOwner == DadsWallet || 
            newOwner == BrosWallet
            ) {
            _owners[newOwner] = true; //we add the newOwner to the mapping of the addresses that are owners
        } else{
        _owners[newOwner] = false; //not sure if its the smartest way
        }
        emit OwnershipGranted(newOwner);
    }

    function MoveTokens(address from, address to, uint id, uint amount) public OnlyOwnersAllowed {
        require(
                to == MomsWallet || 
                to == DadsWallet || 
                to == BrosWallet || 
                to == MyWallet, 
                "You can only transfer to the designated owners"
                );
        super.safeTransferFrom(from, to, id, amount, ""); //function reserved to ERC1155
    }

    /*function LastOne(address from, address to, uint id, uint amount) public{
    if (amount == 4) {
        ????
        "You may sell it to any address"
    }*/

}
