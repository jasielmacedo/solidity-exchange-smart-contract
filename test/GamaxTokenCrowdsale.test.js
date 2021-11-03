const { assert } = require('chai');

const GamaxToken = artifacts.require('./GamaxToken.sol');
const GamaxTokenCrowdsale = artifacts.require('./GamaxTokenCrowdsale.sol');

require('chai').use(require('chai-as-promised')).should();

const moment = require('moment');
const { tokens, wait } = require('../utils.js');

contract('GamaxTokenCrowdsale', ([deployer, investor, investor2]) => {
  let crowdsale;
  let token;
  let _startTimestamp;
  let _endTimestamp;

  before(async () => {
    token = await GamaxToken.deployed();

    _startTimestamp = moment().add(1, 'second').unix();
    _endTimestamp = moment().add(1, 'day').unix();

    crowdsale = await GamaxTokenCrowdsale.new(
      100,
      deployer,
      token.address,
      _startTimestamp,
      _endTimestamp,
      tokens('10')
    );
  });

  describe('deployment', async () => {
    it('should have deployed successfully', async () => {
      const { address } = crowdsale;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, '');
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });
  });

  describe('Crowdsale', async () => {
    it('should receive funds', async () => {
      amount = '1000000000000000000000000';

      await token.transfer(crowdsale.address, amount);

      const contractBalance = await token.balanceOf(crowdsale.address);
      assert.equal(contractBalance.toString(), amount);

      await crowdsale.setTokenBalance();

      const availableCrowdsaleBalance = await crowdsale.tokenBalance();
      assert.equal(availableCrowdsaleBalance.toString(), contractBalance.toString());
    });

    it('crowdsale should not be open', async () => {
      await wait(4000);

      const hasClosed = await crowdsale.hasClosed();
      assert.equal(hasClosed, false);
    });

    it('should invest and not receive tokens', async () => {
      const beforeBalance = (await token.balanceOf(investor2)).toString();

      await crowdsale.buyTokens(investor2, {
        value: web3.utils.toWei('0.1', 'ether'),
        from: investor2,
      });

      const afterBalance = (await token.balanceOf(investor2)).toString();

      assert.equal(beforeBalance, afterBalance);
    });

    it('should finalize the crowdsale', async () => {
      await crowdsale.finalize();

      const hasClosed = await crowdsale.hasClosed();
      assert.equal(hasClosed, true);

      const finalized = await crowdsale.finalized();
      assert.equal(finalized, true);
    });

    it("shouldn't be able to invest because the crowdsale is closed", async () => {
      let error = null;
      try {
        await crowdsale.buyTokens(investor2, {
          value: web3.utils.toWei('0.1', 'ether'),
          from: investor2,
        });
      } catch (e) {
        error = e;
      }

      assert.notEqual(error, null);
    });

    it("should refund the investment because the goal wasn't reached", async () => {
      const goalReached = await crowdsale.goalReached();
      assert.equal(goalReached, false);

      await crowdsale.claimRefund(investor2, { from: investor2 });
    });

    it('should start a new crowdsale, invest and receive tokens', async () => {
      _startTimestamp = moment().add(1, 'second').unix();
      _endTimestamp = moment().add(1, 'day').unix();

      const tempCrowdsale = await GamaxTokenCrowdsale.new(
        100,
        deployer,
        token.address,
        _startTimestamp,
        _endTimestamp,
        tokens('0.1')
      );

      amount = '1000000000000000000000000';

      await token.transfer(tempCrowdsale.address, amount);

      const balanceOfContract = (await token.balanceOf(tempCrowdsale.address)).toString();
      assert.equal(balanceOfContract, amount);

      await tempCrowdsale.setTokenBalance();

      await wait(4000);

      const beforeBalance = (await tempCrowdsale.balanceOf(investor2)).toString();

      await tempCrowdsale.buyTokens(investor2, {
        value: web3.utils.toWei('0.1', 'ether'),
        from: investor2,
      });

      const afterBalance = (await token.balanceOf(investor2)).toString();

      assert.equal(beforeBalance, afterBalance);

      await tempCrowdsale.finalize();

      const hasClosed = await tempCrowdsale.hasClosed();
      assert.equal(hasClosed, true);

      const goalReached = await tempCrowdsale.goalReached();
      assert.equal(goalReached, true);

      // calling this before investor's withdraw to test if they will receive the correct amount of token
      // to garantee their investment
      await tempCrowdsale.withdrawRemainingTokens();

      await tempCrowdsale.withdrawTokens({ from: investor2 });

      const afterWithdraw = (await token.balanceOf(investor2)).toString();

      // checking investors gain
      assert.equal(afterWithdraw, '10000000000000000000');

      const endBalance = (await token.balanceOf(tempCrowdsale.address)).toString();

      assert.equal(endBalance, '0');
    });
  });
});
