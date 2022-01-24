//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Context.sol";

interface IERC721WhitelistedMintable {
    function mint(address to) external;
}

contract Whitelist is Context, AccessControl {
    struct WhitelistedAccount {
        address account;
        uint256 count;
    }

    bytes32 constant WHITELIST_MANAGER = keccak256("WHITELIST_MANAGE");

    mapping(uint256 => mapping(address => uint256)) public whitelists;
    mapping(uint256 => bool) private whitelistStatus;

    IERC721WhitelistedMintable immutable token;

    modifier whitelisted(uint256 listId) {
        require(
            isWhitelisted(listId, _msgSender()),
            "Account is not eligible!"
        );

        _;
    }

    modifier whitelistActive(uint256 listId) {
        require(whitelistStatus[listId], "Whitelist is not active!");

        _;
    }

    modifier whitelistDeactive(uint256 listId) {
        require(!whitelistStatus[listId], "Whitelist is not active!");

        _;
    }

    constructor(address tokenAddress) {
        _setupRole(WHITELIST_MANAGER, _msgSender());

        token = IERC721WhitelistedMintable(tokenAddress);
    }

    function set(uint256 listId, WhitelistedAccount[] calldata accounts)
        public
        virtual
        onlyRole(WHITELIST_MANAGER)
    {
        uint256 count = accounts.length;
        for (uint256 i = 0; i < count; i++) {
            whitelists[listId][accounts[i].account] = accounts[i].count;
        }

        whitelistStatus[listId] = true;
    }

    function deactivate(uint256 listId)
        public
        virtual
        onlyRole(WHITELIST_MANAGER)
    {
        whitelistStatus[listId] = false;
    }

    function activate(uint256 listId)
        public
        virtual
        onlyRole(WHITELIST_MANAGER)
    {
        whitelistStatus[listId] = true;
    }

    function removeFrom(uint256 listId, address[] memory accounts)
        public
        virtual
        onlyRole(WHITELIST_MANAGER)
    {
        uint256 count = accounts.length;
        for (uint256 i = 0; i < count; i++) {
            delete whitelists[listId][accounts[i]];
        }
    }

    function redeemFrom(uint256 listId)
        public
        whitelisted(listId)
        whitelistActive(listId)
    {
        token.mint(_msgSender());

        whitelists[listId][_msgSender()]--;
    }

    function isWhitelisted(uint256 listId, address account)
        public
        view
        virtual
        whitelistActive(listId)
        returns (bool)
    {
        return whitelists[listId][account] > 0;
    }

    function whitelistedAmountOf(uint256 listId, address account)
        public
        view
        virtual
        returns (uint256)
    {
        return whitelists[listId][account];
    }

    function isActive(uint256 listId) public view virtual returns (bool) {
        return whitelistStatus[listId];
    }
}
