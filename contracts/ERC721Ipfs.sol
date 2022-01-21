//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ERC721Ipfs is ERC721, Ownable {
    string ipfsHash;

    function _baseURI() internal view virtual override returns (string memory) {
        return string(abi.encodePacked("ipfs://", ipfsHash, "/"));
    }

    function setIpfsHash(string calldata newIpfsHash) public onlyOwner {
        ipfsHash = newIpfsHash;
    }
}
