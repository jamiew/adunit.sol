// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../AdUnit.sol";
import { Utilities } from "./utils/Utilities.sol";
import { console } from "forge-std/console.sol";
import { Vm } from "forge-std/Vm.sol";


contract AdUnitTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);

    AdUnit ad;

    address forgeDeployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    function setUp() public {
        ad = new AdUnit();
    }

    // helpers
    // n/a

    // tests
    function testConsoleLog() public view {
      console.log("console.log() works in tests");
    }

    function testJoin() public {
        vm.expectEmit(true, false, false, false);
        ad.join();
        // should have emitted JoinedAdNetwork
    }

    function testCurrentPrice() public {
        console.log("current price (0)", ad.currentPrice());
        vm.roll(5);
        console.log("current price (5)", ad.currentPrice());
        vm.roll(10);
        console.log("current price (10)", ad.currentPrice());
        vm.roll(50);
        console.log("current price (50)", ad.currentPrice());
        // assertEq(id, 1);
        // assertEq(addr, validWebsiteAddress);
        // assertEq(tokenId, validWebsiteTokenId);
    }

    function testBuyNow() public {
        // TODO
    }

}
