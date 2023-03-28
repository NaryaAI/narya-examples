// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@narya-ai/contracts/PTest.sol";
import "src/PFP.sol";

contract ERC721TransferFromTest is PTest {
    address alice = address(0x927);
    address agent;

    PFP pfp;
    uint256 id1;
    uint256 id2;

    function setUp() public {
        pfp = new PFP();
        id1 = pfp.mint(alice, "https://narya.ai/1");

        agent = getAgent();
    }

    function testTransferFrom(uint256 id) public {
        try pfp.transferFrom(alice, agent, id) {
            assert(id == id1);
            assert(pfp.ownerOf(id1) == agent);
        } catch {
            assert(pfp.ownerOf(id1) == alice);
        }
    }

    function invariantSafeTransferFrom() public view {
        assert(pfp.ownerOf(id1) == alice);
    }
}
