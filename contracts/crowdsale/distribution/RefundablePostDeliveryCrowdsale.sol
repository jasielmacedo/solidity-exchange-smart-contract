// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./RefundableCrowdsale.sol";

/**
 * @title RefundablePostDeliveryCrowdsale
 * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
 * once the crowdsale has closed and the goal met, preventing refunds to be issued
 * to token holders.
 */
abstract contract RefundablePostDeliveryCrowdsale is RefundableCrowdsale {
    function withdrawTokens() public override {
        require(finalized(), "RefundablePostDeliveryCrowdsale: not finalized");
        require(goalReached(), "RefundablePostDeliveryCrowdsale: goal not reached");

        super.withdrawTokens();
    }
}
