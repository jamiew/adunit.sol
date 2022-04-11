// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../WebRing.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol"; // FIXME i think this is in forge-std too
import {Vm} from "forge-std/Vm.sol";


contract AdUnitTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    // CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    Ad ad;

    address forgeDeployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    function setUp() public {
        ad = new WebRing();
    }

    // helpers
    function joinAdNetwork() private {
        ad.join();
        // should have emitted JoinedAdNetwork
    }

    // tests
    function testConsoleLog() public {
      console.log("console.log() works in tests");
    }

    function testWebsiteInfo() public {
      console.log("current price (0)", currentPrice());
      cheats.roll(5);
      console.log("current price (5)", currentPrice());
      cheats.roll(10);
      console.log("current price (10)", currentPrice());
      cheats.roll(50);
      console.log("current price (50)", currentPrice());
      // assertEq(id, 1);
      // assertEq(addr, validWebsiteAddress);
      // assertEq(tokenId, validWebsiteTokenId);
    }

    function contractAddressFor() public {
      joinWebring();
      assertEq(
        webring.contractAddressFor(forgeDeployer),
        validWebsiteAddress
      );
    }

}
