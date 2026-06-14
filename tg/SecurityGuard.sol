// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SecurityGuard is ERC721, Ownable {

    uint256 private _nextTokenId;

    mapping(uint256 => string) private _tokenURIs;
    mapping(address => bool) public hasTitle;

    event GuardTitleGranted(
        address indexed to,
        uint256 indexed tokenId,
        string metadataURI
    );

    constructor()
        ERC721("Permanent Security Guard", "PSG")
        Ownable(msg.sender)
    {}

    function grantGuardTitle(
        address to,
        string memory metadataURI
    ) external onlyOwner {

        require(to != address(0), "Dia chi khong hop le");
        require(!hasTitle[to], "Da co danh hieu");

        uint256 tokenId = _nextTokenId++;

        hasTitle[to] = true;

        _safeMint(to, tokenId);

        _tokenURIs[tokenId] = metadataURI;

        emit GuardTitleGranted(
            to,
            tokenId,
            metadataURI
        );
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);
        return _tokenURIs[tokenId];
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override returns (address) {

        address from = _ownerOf(tokenId);

        // Chỉ cho phép mint ban đầu
        if (from != address(0)) {
            revert("NFT nay la danh hieu vinh vien");
        }

        return super._update(
            to,
            tokenId,
            auth
        );
    }
}