const { assert } = require('chai');

const GameToken = artifacts.require('./GameToken.sol');

require('chai').use(require('chai-as-promised')).should();

contract('GameToken', ([deployer]) => {
  let token;

  before(async () => {
    token = await GameToken.deployed();
  });

  describe('deployment', async () => {
    it('should deployed successfully', async () => {
      const { address } = token;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, '');
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });

    it('deployer should have balance', async () => {
      const deployerBalance = await token.balanceOf(deployer);
      assert.equal(deployerBalance.toString(), '1000000000000000000000000000');
    });
  });
});
