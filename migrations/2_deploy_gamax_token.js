const GamaxToken = artifacts.require('GamaxToken');
const GamaxTokenCrowdsale = artifacts.require('GamaxTokenCrowdsale');
const moment = require('moment');

const { tokens } = require('../utils.js');

module.exports = async function (deployer) {
  deployer.deploy(GamaxToken);
  const token = await GamaxToken.deployed();

  const _startTimestamp = moment().add(10, 'seconds').unix();
  const _endTimestamp = moment().add(30, 'days').unix();

  // deploying contract with rate of 100 and goal of 10 ether just for tests
  deployer.deploy(
    GamaxTokenCrowdsale,
    100,
    '0x1Ba3ca3ea2a38168b8D1FB493D7652ef1fBfCf91',
    token.address,
    _startTimestamp,
    _endTimestamp,
    tokens('10')
  );
};
