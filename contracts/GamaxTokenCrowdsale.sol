// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import './crowdsale/Crowdsale.sol';
import './crowdsale/validation/TimedCrowdsale.sol';
import "./crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract GamaxTokenCrowdsale is RefundablePostDeliveryCrowdsale {

    constructor(
        uint256 rate_,
        address payable wallet_,
        IERC20 token_,
        uint256 openingTime_,
        uint256 closingTime_,
        uint256 goal_
    )
        PostDeliveryCrowdsale()
        TimedCrowdsale(openingTime_, closingTime_)
        RefundableCrowdsale(goal_)
        Crowdsale(rate_, wallet_, token_)
    {}

    /**
     * @dev Set the balance for this crowdsale.
     */
    function setTokenBalance() public onlyOwner {
      _setTokenBalance();
    }

    /**
     * @dev Finalize this crowdsale enabling refund if the goal hasn't been reached or enable investor to withdraw their tokens
     */
    function finalize() public override onlyOwner {
      if(_closingTime > block.timestamp)
        _closingTime = block.timestamp - 1;

      super.finalize();
    }

    /**
     * @dev if exists any remaining tokens, transfer to the wallet address avoiding stuck tokens
     * Check if the goal was reached to only transfer the value not sold to avoid removing purchased tokens from their owners
     * Otherwise transfer all tokens to the wallet considering that the refund is enable
     */
    function withdrawRemainingTokens() public onlyOwner {
      require(hasClosed(), 'The crowdsale is not closed yet');
      require(finalized(), 'the crowdsale is not finalized yet');
      require(tokenBalance() > 0, 'Only available if tokenBalance is greater than zero');
      if(goalReached())
        token().transfer(wallet(), tokenBalance());
      else
      {
        uint256 currentBalance = token().balanceOf(address(this));
        require(currentBalance > 0, 'There is no balance available to transfer');
        token().transfer(wallet(), currentBalance);
      }
    }

    /**
     * @dev Extend crowdsale only if the crowdsale is not closed
     * @param newClosingTime Crowdsale closing time
     */
    function extendTime(uint256 newClosingTime) public onlyOwner {
      _extendTime(newClosingTime);
    }
}
