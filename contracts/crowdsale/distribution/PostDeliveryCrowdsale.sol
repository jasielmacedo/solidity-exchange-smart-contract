// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "../validation/TimedCrowdsale.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../ownership/Secondary.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title PostDeliveryCrowdsale
 * @dev Crowdsale that locks tokens from withdrawal until it ends.
 */
abstract contract PostDeliveryCrowdsale is TimedCrowdsale {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    /**
     * @dev Withdraw tokens only after crowdsale ends.
     */
    function withdrawTokens() public virtual {
        address beneficiary = _msgSender();
        require(hasClosed(), "PostDeliveryCrowdsale: not closed");
        uint256 amount = _balances[beneficiary];
        require(amount > 0, "PostDeliveryCrowdsale: beneficiary is not due any tokens");

        _balances[beneficiary] = 0;
        token().transfer(beneficiary, amount);
    }

    /**
     * @return the balance of an account.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev Overrides parent by storing due balances, and delivering tokens to the vault instead of the end user. This
     * ensures that the tokens will be available by the time they are withdrawn (which may not be the case if
     * `_deliverTokens` was called later).
     * @param beneficiary Token purchaser
     * @param tokenAmount Amount of tokens purchased
     */
    function _processPurchase(address beneficiary, uint256 tokenAmount) internal override {
        _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
        _tokenBalance = _tokenBalance.sub(tokenAmount);
    }
}
