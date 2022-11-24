// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {PTest} from "@pwnednomore/contracts/PTest.sol";
import {VulnerableDoor} from "src/callback/VulnerableDoor.sol";

// An invariant test runs as follows:
// 1. testContract.setup()
// 2. Call a random function in target contract, or a random `actionXXX` function in this test contract
// 3. testContract.invariantXXX(), which is specified when this test runs
// 4. Goto step 2
//
// The `testXXX` named functions are Property Tests. They will be
// called multiple times with different smartly guessed random inputs.
//
// Both test types can share the same `setUp()` function. For more details,
// see https://pwned-no-more.notion.site/Property-test-and-invariant-test-c6b80f6b6136408ba41247c0be561fe2
contract BasicTest is PTest {
    address owner = address(0x1);
    address user = address(0x37);
    ERC20 usdc_contract;
    VulnerableDoor target;

    function setUp() public {
        asAccountBegin(owner);
        usdc_contract = new ERC20("USDC", "USDC");
        target = new VulnerableDoor();
        asAccountEnd();
    }

    // This function will be called randomly along with other methods in the target contract
    function actionAsUserAndOpenDoor() external {
        asAccountBegin(user);
        target.open(address(usdc_contract));
        asAccountEnd();

        // Optional verifying
        assert(target.is_open());
    }

    // This is the verification method, which is called after every random actions
    function invariantDoorIsAlwaysSafe() external {
        assert(!target.stolen());
    }

    // You could define multiple test methods in one test suite,
    // but only one will be used for a single run
    function invariantYetAnotherTest() external {
        assert(!target.is_open());
    }

    // This function will be called again and again, with intelligently selected random data
    function testDoorCanAlwaysBePaint(string memory color) external {
        target.paint(color);
        require(keccak256(bytes(target.color())) == keccak256(bytes(color)));
    }
}
