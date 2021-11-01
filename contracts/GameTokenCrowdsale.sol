// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './crowdsale/Crowdsale.sol';
import './crowdsale/validation/TimedCrowdsale.sol';
import './crowdsale/validation/CappedCrowdsale.sol';

contract GameTokenCrowdsale is CappedCrowdsale {

    constructor(
        uint256 rate_,            // rate, in TKNbits
        address payable wallet_,  // wallet to send Ether
        IERC20 token_,            // the token
        uint256 openingTime_,     // opening time in unix epoch seconds
        uint256 closingTime_,     // closing time in unix epoch seconds
        uint256 goal_,           // refundable goal
        uint256 maxCap_           // max cap to the crowd sale
    )
        CappedCrowdsale(maxCap_)
        PostDeliveryCrowdsale()
        TimedCrowdsale(openingTime_, closingTime_)
        Crowdsale(rate_, wallet_, token_)
        RefundableCrowdsale(goal_)
    {}
}
