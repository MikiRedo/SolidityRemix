// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.1/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";

contract ClimateCoin is ERC20, ERC20Burnable, Ownable {
    constructor(address initialOwner)
        ERC20("ClimateCoin", "CC")
        Ownable(initialOwner)
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);  //solo el owner puede mintear, así que a priori no deberia problemas de mintear maliciosamente
    }
}

//total supply??
