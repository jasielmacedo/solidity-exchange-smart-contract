// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './crowdsale/Crowdsale.sol';
import './crowdsale/validation/TimedCrowdsale.sol';
import "./crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract GamaTokenCrowdsale is RefundablePostDeliveryCrowdsale {

    constructor(
        uint256 rate_,
        address payable wallet_,
        IERC20 token_,
        uint256 openingTime_,
        uint256 closingTime_,
        uint256 goal_,
        uint256 maxCap_
    )
        PostDeliveryCrowdsale()
        TimedCrowdsale(openingTime_, closingTime_)
        RefundableCrowdsale(goal_)
        Crowdsale(rate_, wallet_, token_)
    {}
}
