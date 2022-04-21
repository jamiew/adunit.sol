// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "openzeppelin-contracts/token/ERC721/IERC721Receiver.sol";
import "../AdUnit.sol";


contract AdUnitTest is Test, IERC721Receiver {
    address forgeDeployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    AdUnit ad;

    // FIXME any way to DRY with the main contract?
    // forge examples have it duplicated inside test contract too
    event JoinedAdNetwork(address indexed who);

    function setUp() public {
        ad = new AdUnit();
    }

    function testConsoleLog() public view {
        console.log("console.log() works in tests");
    }

    function testJoin() public {
        assertEq(ad.balanceOf(address(this)), 0);
        vm.expectEmit(true, false, false, false);
        emit JoinedAdNetwork(address(this));
        ad.join();
        assertEq(ad.balanceOf(address(this)), 1);
    }

    function testFailIfJoinTwice() public {
        ad.join();
        ad.join();
    }

    function testHasJoined() public {
        ad.join();
        assertTrue(ad.hasJoined());
    }

    function testFailNotJoinedByDefault() public {
        assertTrue(ad.hasJoined());
    }

    function testCurrentPrice() public {
        console.log("current price", block.number, ad.currentPrice());
        vm.roll(5);
        console.log("current price", block.number, ad.currentPrice());
        vm.roll(10);
        console.log("current price", block.number, ad.currentPrice());
        vm.roll(50);
        console.log("current price", block.number, ad.currentPrice());
    }

    function testDefaultCurrentAd() public {
        (
            uint256 id,
            address buyer,
            uint256 blockNum,
            string memory headline,
            string memory subhead,
            string memory url
        ) = ad.currentAd();
        assertEq(id, 0);
        assertEq(buyer, address(0));
        assertEq(blockNum, block.number);
        assertEq(headline, "");
        assertEq(subhead, "");
        assertEq(url, "");
    }

    function testBuyNow() public {
        vm.deal(address(this), 100 ether);
        uint price = ad.currentPrice();
        ad.buyNow{value: price}("Foobar", "Bob", "https://example.com");

        (
            uint256 id,
            address buyer,
            uint256 blockNum,
            string memory headline,
            string memory subhead,
            string memory url
        ) = ad.currentAd();
        assertEq(id, 1);
        assertEq(buyer, address(this));
        assertEq(blockNum, block.number);
        assertEq(headline, "Foobar");
        assertEq(subhead, "Bob");
        assertEq(url, "https://example.com");
    }

    function testFailBuyNowRequiresMoney() public {
        ad.buyNow("Cheapskate", "Pay up", "https://buynow.com");
    }

    function testFailBuyNowRequiresCorrectAmountOfMoney() public {
        assertGt(ad.currentPrice(), 100);
        ad.buyNow{value: 100}("Still cheap", "Pay more", "https://ok.com");
    }

    function testTokenURI() public view {
        // hard to do much but just ensure that it doesn't throw an error
        ad.tokenURI(1);
        ad.tokenURI(666);
    }

    // required by solidity
    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

}
