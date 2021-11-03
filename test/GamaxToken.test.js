const { assert } = require('chai');

const GamaxToken = artifacts.require('./GamaxToken.sol');

require('chai').use(require('chai-as-promised')).should();

contract('GamaxToken', ([deployer]) => {
  let token;

  before(async () => {
    token = await GamaxToken.deployed();
  });

  describe('deployment', async () => {
    it('should have deployed successfully', async () => {
      const { address } = token;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, '');
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });

    it('deployer should have balance', async () => {
      const deployerBalance = await token.balanceOf(deployer);
      assert.equal(deployerBalance.toString(), '10000000000000000000000000000');
    });
  });
});
