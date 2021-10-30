const { assert } = require('chai');

const GameToken = artifacts.require('./GameToken.sol');
const GameTokenPoolExchange = artifacts.require('./GameTokenPoolExchange.sol');

const tokens = n => web3.utils.toWei(n, 'ether');

require('chai').use(require('chai-as-promised')).should();

contract('GameTokenPoolExchange', ([deployer, investor]) => {
  let pool;
  let token;

  before(async () => {
    token = await GameToken.deployed();
    pool = await GameTokenPoolExchange.deployed();
  });

  describe('deployment', async () => {
    it('should deployed successfully', async () => {
      const { address } = pool;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, '');
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });

    it('should set token address', async () => {
      await pool.setToken(token.address);
    });
  });

  describe('pooling and exchanging', async () => {
    it('should transfer balance from token to pool', async () => {
      const amount = (await token.balanceOf(deployer)).toString();

      assert.notEqual(amount, '0');

      await token.transfer(pool.address, amount);

      const poolBalance = await token.balanceOf(pool.address);
      assert.equal(poolBalance.toString(), amount);
    });

    it('should buy some coins', async () => {
      const poolBalanceDirect = await token.balanceOf(pool.address);

      const poolBalance = (await pool.tokenBalance()).toString();

      assert.equal(poolBalanceDirect, poolBalance);
      assert.notEqual(poolBalance, '0');

      await pool.buyTokens({
        from: investor,
        value: tokens('0.01'),
      });

      const purchasedToken = (await token.balanceOf(investor)).toString();
      assert.equal(purchasedToken, tokens('1').toString());
    });

    it('should change the rate and receive more coins', async () => {
      await pool.setRate(1000);

      await pool.buyTokens({
        from: investor,
        value: tokens('0.01'),
      });

      const purchasedToken = (await token.balanceOf(investor)).toString();
      assert.equal(purchasedToken, tokens('11').toString());
    });
  });
});
