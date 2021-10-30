const GameToken = artifacts.require('GameToken');
const GameTokenPoolExchange = artifacts.require('GameTokenPoolExchange');

module.exports = async function (deployer) {
  deployer.deploy(GameToken);
  const token = await GameToken.deployed();

  deployer.deploy(GameTokenPoolExchange, token.address);
};
