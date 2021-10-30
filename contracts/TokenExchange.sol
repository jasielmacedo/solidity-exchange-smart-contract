// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


abstract contract TokenExchange is Ownable, Pausable {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  // token interface
  IERC20 internal _token;

  // rate to multiply during purchase process
  uint256 internal _rate;

  event TokenPurchased(
    address buyer,
    address token,
    uint256 amount,
    uint256 rate
  );

  constructor(address purchasableToken, uint256 rate_){
    _token = IERC20(purchasableToken);
    _rate = rate_;
  }

  function buyTokens() public payable whenNotPaused {
    require(msg.value > 0, 'value has to be greater than 0');

    // multiply the received amount per rate
    uint256 tokensToTransfer = msg.value.mul(rate());

    // check the tokenExchange balance of this token
    require(tokenBalance() >= tokensToTransfer, "liquidity pool hasn't enough token");

    // transfer the amount to the buyer
    _token.safeTransfer(msg.sender, tokensToTransfer);

    // emits the event
    emit TokenPurchased(msg.sender, address(_token), tokensToTransfer, _rate);
  }

  function rate() public view returns (uint256) {
    return _rate;
  }

  function tokenBalance() public view returns (uint256) {
    return _token.balanceOf(address(this));
  }

  // only owners

  // set token to use to exchange
  function setToken(address purchasableToken) public onlyOwner {
    _token = IERC20(purchasableToken);
  }

  // set rate equivalence
  function setRate(uint256 rate_) public onlyOwner {
    _rate = rate_;
  }

  // security: set the flag paused to true to stop whenNotPaused calls
  function pause() public onlyOwner {
    _pause();
  }

  // security: set the flag paused to false
  function unpause() public onlyOwner {
    _unpause();
  }
}
