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
    address public developer;
    
    event creditsIn(address developer, uint credits); //event cuando recibimos los creditos
    event NFTMinted(uint indexed tokenID, string projectName, string projectURL, address indexed developer, uint credits); //event cuando minteamos nft
    event NFTexchanged(address developer, uint credits, address owner);
    event CCBurn(uint ccAmount, uint tokenID);

    constructor(address initialOwner, address _climateCoin) ERC721("Climate NFT", "CNFT") Ownable(initialOwner) {
        climateCoin = IERC20(_climateCoin);
        //interaccion con el otro SC
    } 

    // función para cambiar el estado, si recibimos los créditos, lo pasamos a true. Primera funcion a allamar ara actualizar el bool
    function setReceivedCredits(bool status, uint creditsRecived) external onlyOwner {
        receivedCredits = status;
        credits = creditsRecived;
        tokenID = creditsRecived;   //asociaciamos el tokenID al numero de creditos, asi es mas facil luego la quema de tokens
        emit creditsIn(developer, credits);  //evento señalando que los creditos han sido mandados
    }


    // mintear directamente en la wallet del developer, un solo nft equivalente a x créditos
    function mintNFT(address _developer, string memory _projectName, string memory _projectURL) external onlyOwner {
        require(receivedCredits, "Credits not received yet");
        //implementar mes errores o casos
        developer = _developer;
        projectName = _projectName;
        projectURL = _projectURL;

        _safeMint(developer, tokenID);

        emit NFTMinted(tokenID, projectName, projectURL, developer, credits);
    }


    function setFeePercentage(uint256 newFeePercentage) public onlyOwner {
        feePercentage = newFeePercentage;
    }


    function exchangeNFTForCC(uint tokenId, uint amount) external onlyOwner {
        require(amount == credits);                                         //amount debe ser igual al numero de creditos
        require(ownerOf(tokenId) == developer, "Youre not the owner");
        require(balanceOf(address(this)) >= credits, "Not enough ClimateCoins in contract"); //check si el contrato tienen suficientes CC para enviar

        uint realAmount = amount - (amount * feePercentage);                    //calculamos el fee que restaremos al amount final

        safeTransferFrom(developer, msg.sender, tokenId);                       //mandamos del developer al creador del contrato el NFT

        climateCoin.transferFrom(msg.sender, developer, realAmount);            //mandamos del creador al developer los CC
      
        emit NFTexchanged(developer, credits, msg.sender);
    }


    function burnCCAndNFT(uint ccAmount) external onlyOwner {
        if (ccAmount == tokenID) {  //tokenID es igual a los creditos asociados, aka mismo numero que CC
            _burn(tokenID);
            _burn(ccAmount);
        } 
        else {
            revert("Token ID has no coincidences");
        }
        emit CCBurn(ccAmount, tokenID);
    }
}
