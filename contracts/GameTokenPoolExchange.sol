// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./TokenExchange.sol";

contract GameTokenPoolExchange is TokenExchange {
  constructor(address gameToken) TokenExchange(gameToken, 100) {}

  function withdraw() public payable onlyOwner {
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
  }
}
