pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTProject is ERC721URIStorage, Ownable {

  constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

  function letsMint (address _to, uint256 _id, string calldata requestedURI) public onlyOwner {
    ERC721(0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9).transferFrom(msg.sender, address(this), 1);
    _safeMint(_to, _id);
    _setTokenURI(_id, requestedURI);
  }

}
