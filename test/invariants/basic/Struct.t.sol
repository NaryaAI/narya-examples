// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "src/basic/Struct.sol";
import "@narya-ai/contracts/PTest.sol";

contract StructTest is PTest {
    Struct st;

    address agent;

    function setUp() public {
        st = new Struct();

        agent = getAgent();
    }

    function testSetFlags(Param calldata x, Param calldata y) public {
        st.set0(x);
        st.set1(y);
        assert(st.flag1());
    }

    function invariantFlagIsTrue() public view {
        assert(st.flag1());
    }
}
