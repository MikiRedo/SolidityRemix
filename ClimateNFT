// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ClimateNFT is ERC721, ERC721Burnable, Ownable {

    bool public receivedCredits;  // false por defecto
    uint public tokenID;
    string public projectName;
    string public projectURL;
    uint public credits;

    event NFTMinted(uint indexed tokenID, string projectName, string projectURL, address indexed developer, uint credits);

    constructor(address initialOwner, string memory _projectName, string memory _projectURL) ERC721("Climate NFT", "CNFT") Ownable(initialOwner) {
        projectName = _projectName;
        projectURL = _projectURL;
    } 

    // función para cambiar el estado, si recibimos los créditos, lo pasamos a true
    function setReceivedCredits(bool status, uint creditsRecived) external onlyOwner {
        receivedCredits = status;
        credits = creditsRecived;
    }

    // mintear directamente en la wallet del developer, un solo nft equivalente a x créditos
    function mintNFT(address developer) external onlyOwner {
        require(receivedCredits, "Credits not received yet");
        _safeMint(developer, tokenID);
        tokenID++;

        emit NFTMinted(tokenID, projectName, projectURL, developer, credits);
    }
}
