//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

abstract contract BaseERC2981 is IERC2981 {
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        virtual
        override
        returns (address receiver, uint256 royaltyAmount);

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return interfaceId == type(BaseERC2981).interfaceId;
    }
}

abstract contract ERC721Royalty is BaseERC2981, ERC721 {
    uint256 public royalty;
    address public receiverAccount;

    function setReceiver(address account) external {
        receiverAccount = account;
    }

    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        virtual
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        return (receiverAccount, salePrice * royalty);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(BaseERC2981, ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
