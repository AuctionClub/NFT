// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
contract FakeEfrogsNFT is ERC721, ERC721URIStorage, ERC721Enumerable, Ownable {
    uint256 private _tokenIdCounter;
    // 定义一个事件，当NFT铸造成功时触发
    event NFTMinted(uint256 indexed tokenId, string tokenURI);
    event NFTBurned(uint256 indexed tokenId);
    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) Ownable(msg.sender) {
        _tokenIdCounter = 1;
    }
    function _increaseBalance(
        address account,
        uint128 value
    ) internal virtual override(ERC721, ERC721Enumerable) {
        return super._increaseBalance(account, value);
    }
    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal virtual override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }
    function totalSupply()
        public
        view
        override(ERC721Enumerable)
        returns (uint256)
    {
        return super.totalSupply();
    }
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721URIStorage, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function safeMint(address to, string memory _tokenURI) public onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        // 触发 NFTMinted 事件
        emit NFTMinted(tokenId, _tokenURI);
    }
    function updateTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) public onlyOwner {
        require(
            _ownerOf(tokenId) != address(0),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _setTokenURI(tokenId, _tokenURI);
    }
    function batchMint(
        address to,
        string[] memory _tokenURIs
    ) public onlyOwner {
        for (uint256 i = 0; i < _tokenURIs.length; i++) {
            safeMint(to, _tokenURIs[i]);
        }
    }
    function burn(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        _checkAuthorized(owner, msg.sender, tokenId);
        _burn(tokenId);
        emit NFTBurned(tokenId);
    }
}
