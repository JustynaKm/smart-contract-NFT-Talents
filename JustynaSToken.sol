// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.9.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.3/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.9.3/security/Pausable.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.3/utils/Counters.sol";

contract JustynaSToken is ERC721, ERC721Enumerable, Pausable, Ownable {

     // ===== 1. Property Variables ===== //
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public MINT_PRICE = 0.05 ether;
    uint public MAX_SUPPLY = 100;

     // ===== 2. Lifecycle Methods ===== //

    constructor() ERC721("Justyna'sToken", "HM") {
        // Start token ID at 1. By default is starts at 0.
        _tokenIdCounter.increment();
    }
    function withdraw() public onlyOwner() {
        require(address(this).balance > 0, "Balance is zero");
        payable(owner()).transfer(address(this).balance);
    }
    // ===== 3. Pauseable Functions ===== //

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    // ===== 4. Minting Functions ===== //

     function safeMint(address to) public payable {
        // ❌ Check that totalSupply is less than MAX_SUPPLY
        require(totalSupply() < MAX_SUPPLY, "Can't mint anymore tokens.");

     // ❌ Check if ether value is correct
        require(msg.value >= MINT_PRICE, "Not enough ether sent.");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
    // ===== 5. Other Functions ===== //

       function _baseURI() internal pure override returns (string memory) {
        return "ipfs://JustynaSTokenBaseURI/";
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}


/* NOTES:
    contract address:0xd9145CCE52D386f254917e481eB44e9943F39138

    owner address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    - deployed contract
    address 2 : 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    - mint 1 NFT

    */