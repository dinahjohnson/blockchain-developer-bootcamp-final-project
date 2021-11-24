pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Reward is ERC721URIStorage {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() public ERC721("Rewards", "GRINGOTTS") {}

  
  // @param tokenURI = json url for NFT https://jsonkeeper.com/
  function claimReward(string memory tokenURI)
    public
  {
    uint256 newId = _tokenIds.current();

    _safeMint(msg.sender, newId);
    _setTokenURI(newId, tokenURI);

    _tokenIds.increment();
  }
}