// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract FakeEfrogsNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    // 定义一个事件，当NFT铸造成功时触发
    event NFTMinted(uint256 indexed tokenId, string tokenURI);
    event NFTBurned(uint256 indexed tokenId);
    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) Ownable(msg.sender) {}

    function safeMint(address to, string memory _tokenURI) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
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
            _exists(tokenId),
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
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Caller is not owner nor approved"
        );
        _burn(tokenId);
        emit NFTBurned(tokenId);
    }
}
