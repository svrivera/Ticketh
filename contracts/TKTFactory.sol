// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TKTFactory is ERC721, PullPayment, Ownable {
  using Counters for Counters.Counter;

  Counters.Counter private currentTokenId;

  string public baseTokenURI;
  uint256 public mintingPrice = 0.01 ether;
  uint256 public totalSupply;
  mapping(uint256 => string) private _owners;

  constructor(uint256 _totalSupply) ERC721("TickETH", "TKT") {
    baseTokenURI = "";
    totalSupply = _totalSupply;
  }

  /// @dev Sets the ownerId for the given token ID.
  function setTickETHOwnerId(
    uint256 tokenId,
    string memory ownerId
    ) private {
    require(bytes(ownerId).length > 0, "Owner ID cannot be empty");
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    _owners[tokenId] = ownerId;
  }

  /// @dev Mints a new token.
  function mintTickETH(string memory ownerId) public payable returns (uint256) {
    uint256 tokenId = currentTokenId.current();
    require(tokenId < totalSupply, "Max supply reached");
    require(msg.value == mintingPrice, "Transaction value did not equal the mint price");

    currentTokenId.increment();
    uint256 newItemId = currentTokenId.current();
    _safeMint(msg.sender, newItemId);
    setTickETHOwnerId(newItemId, ownerId);
    return newItemId;
  }

   /// @dev Returns the ownerId for the given token ID.
  function getTickETHOwnerId(uint256 tokenId) public view onlyOwner returns (string memory) {
    return _owners[tokenId];
  }

  /// @dev Sets the base token URI prefix.
  function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
    baseTokenURI = _baseTokenURI;
  }

  /// @dev Returns the URI for the given token ID.
  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }

  /// @dev Overriden in order to set the new owner
  function TickETHTransferFrom(
    uint256 tokenId,
    address newOwner,
    string memory ownerId
    ) public {
    require(ownerOf(tokenId) == msg.sender, "ERC721: transfer caller is not owner");
    require(newOwner != address(0), "ERC721: new owner is the zero address");
    super.safeTransferFrom(msg.sender, newOwner, tokenId);
    setTickETHOwnerId(tokenId, ownerId);
  }

  /// @dev Overridden in order to make it an onlyOwner function
  function withdrawPayments(address payable payee) public override onlyOwner virtual {
      super.withdrawPayments (payee);
  }
}
