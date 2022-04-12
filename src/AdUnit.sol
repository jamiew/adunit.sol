// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "./Base64.sol";

contract AdUnit is ERC721 {

  struct Ad {
    uint256 id;
    address creator;
    uint256 createdAtBlock;
    string headline;
    string subhead;
    string url;
  }

  uint256 public adsCount;
  Ad currentAd;
  uint256 lastPricePaid;
  uint256 lastPaymentBlock;
  address lastPayer;

  uint256 public startingPrice = 0.001 ether;

  event AdChanged(uint256 indexed id, address indexed newCreator, string headline, string subhead, string url);
  event JoinedAdNetwork(address indexed who);

  modifier paidEnough () {
    // TODO
    // test payable amount is >= currentPrice()
    _;
  }

  constructor() ERC721("AdUnit", "AD") {
    // nothing to see here
  }

  function currentPrice() public view returns (uint256) {
    if (lastPricePaid == 0) return startingPrice;
    // increase price by a large % for a while after purchase
    // decay back to initial price after another 20k blocks -- approximately 3 days
    uint256 blockDiff = block.number - lastPaymentBlock;
    return (lastPricePaid / (blockDiff / 20000)) + startingPrice;
  }

  function buyNow(string memory headline, string memory subhead, string memory url) public payable
  paidEnough() {
    adsCount++;
    uint256 nextId = adsCount;

    currentAd = Ad(
      nextId,
      _msgSender(),
      block.number,
      headline,
      subhead,
      url
    );

    emit AdChanged(
      nextId,
      _msgSender(),
      headline,
      subhead,
      url
    );
  }

  function join() public {
    require(balanceOf(_msgSender()) == 0); // only one per person
    _safeMint(_msgSender(), 1);
    emit JoinedAdNetwork(_msgSender());
  }

  function tokenURI(uint256 tokenId) override public view returns (string memory) {
      string[7] memory parts;
      parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="white" /><text x="10" y="20" class="base">';
      parts[1] = currentAd.headline;
      parts[2] = '</text><text x="10" y="40" class="base">';
      parts[3] = currentAd.subhead;
      parts[4] = '</text><text x="10" y="60" class="base">';
      parts[5] = currentAd.url;
      parts[6] = '</text><text x="10" y="80" class="base">';

      string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]));
      string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Universal Ad Unit', Strings.toString(tokenId), '", "description": "This is Universal Ad Unit, Buy Now at BuyNow.BuyNow", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
      output = string(abi.encodePacked('data:application/json;base64,', json));
      return output;
  }

}
