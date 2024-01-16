// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ClimateNFT is ERC721, ERC721Burnable, Ownable {

    bool public receivedCredits;  // false por defecto
    uint public credits;
    
    uint public tokenID;
    string public projectName;
    string public projectURL;
    

    event NFTMinted(uint indexed tokenID, string projectName, string projectURL, address indexed developer, uint credits);

    //el token siempre se llamara asi, aunque luego el nft sea distinto para cada proyecto (tokenID++)
    constructor(address initialOwner) ERC721("Climate NFT", "CNFT") Ownable(initialOwner) 
    {} 

    // función para cambiar el estado, si recibimos los créditos, lo pasamos a true
    function setReceivedCredits(bool status, uint creditsRecived) external onlyOwner {
        receivedCredits = status;
        credits = creditsRecived;
    }

    // mintear directamente en la wallet del developer, un solo nft equivalente a x créditos
    function mintNFT(address developer, string memory _projectName, string memory _projectURL) external onlyOwner {
        require(receivedCredits, "Credits not received yet");
        projectName = _projectName;
        projectURL = _projectURL;

        _safeMint(developer, tokenID);
        tokenID++;

        emit NFTMinted(tokenID, projectName, projectURL, developer, credits);
    }
}
