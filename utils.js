const BigNumber = require('bignumber.js');

const tokens = n => BigNumber((n * 10 ** 18).toString());

const wait = ms => new Promise(resolve => setTimeout(resolve, ms));

module.exports = { tokens, wait };
