// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GameToken is ERC20, ERC20Burnable, Pausable, Ownable {
  event PlayerRewarded(address player, uint256 amount);

  // initialize the contract
  constructor() ERC20("GameToken", "GMTK") {
    _mint(msg.sender, 1_000_000_000 * 10**decimals());
  }

  // security: set the flag paused to true to stop whenNotPaused calls
  function pause() public onlyOwner {
    _pause();
  }

  // security: set the flag paused to false
  function unpause() public onlyOwner {
    _unpause();
  }

  function rewardPlayer(address _to, uint256 _tokenAmount)
    public
    onlyOwner
    whenNotPaused
  {
    // the owner must have the correct amount
    require(balanceOf(msg.sender) <= _tokenAmount);
    // transfer the amount to the player
    transferFrom(msg.sender, _to, _tokenAmount);
    // emit the event
    emit PlayerRewarded(_to, _tokenAmount);
  }

  // creates an override version to avoid transfering when paused
  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 amount
  ) internal override whenNotPaused {
    super._beforeTokenTransfer(from, to, amount);
  }
}
