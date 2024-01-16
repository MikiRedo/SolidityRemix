// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ClimateNFT is ERC721, ERC721Burnable, Ownable {
    
    IERC20 public climateCoin; //funciones basicas del standard

    bool public receivedCredits;  // false por defecto
    uint public credits;
    uint256 public feePercentage;
    uint public tokenID;
    string public projectName;
    string public projectURL;
    

    event NFTMinted(uint indexed tokenID, string projectName, string projectURL, address indexed developer, uint credits);

    constructor(address initialOwner, address _climateCoin) ERC721("Climate NFT", "CNFT") Ownable(initialOwner) {
        climateCoin = IERC20(_climateCoin);
        //interaccion con el otro SC
    } 

    // función para cambiar el estado, si recibimos los créditos, lo pasamos a true
    function setReceivedCredits(bool status, uint creditsRecived) external onlyOwner {
        receivedCredits = status;
        credits = creditsRecived;
    }

    // mintear directamente en la wallet del developer, un solo nft equivalente a x créditos
    function mintNFT(address developer, string memory _projectName, string memory _projectURL) external onlyOwner {
        require(receivedCredits, "Credits not received yet");
        //implementar mes errores o casos
        projectName = _projectName;
        projectURL = _projectURL;

        _safeMint(developer, tokenID);
        tokenID++;

        emit NFTMinted(tokenID, projectName, projectURL, developer, credits);
    }

    function setFeePercentage(uint256 newFeePercentage) public onlyOwner {
        feePercentage = newFeePercentage;
        //implementar errores o casos
    }

    function exchangeNFTForCC(address ddd, uint _tokenID) public {
        //implementar logica del swap
    }
}
