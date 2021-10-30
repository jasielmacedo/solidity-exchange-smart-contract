# solidity-exchange-smart-contract

I've create this project to explore the possibility of creating smart contracts to do token exchange

## Setup

[Instructions to install Truffle Ganache](https://www.trufflesuite.com/ganache)

Make sure to start ganache before every interaction with this project

Install NVM:

```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
```

Install latest Node Erbium LTS and set to default:

```
nvm install --lts=Erbium && nvm use --lts=Erbium && nvm alias default `nvm current`
```

Install dependencies:

```
npm install
```

## Running

Compiling contracts:

```
truffle compile
```

Deploying contracts:

```
truffle migrate --reset
```

Testing contracts:

```
npm test
```

## Contract deploy address

### Game Token

Mumbai testnet: [0x16478bd92e713a5599898c2c3b4713c47c5d39d1](https://mumbai.polygonscan.com/token/0x16478bd92e713a5599898c2c3b4713c47c5d39d1)

### Game Token Pool Exchange

Mumbai testnet: [0x3c2C22AE04A488f38cCF1Fe8C88B12d2A95c9B5A](https://mumbai.polygonscan.com/address/0x3c2C22AE04A488f38cCF1Fe8C88B12d2A95c9B5A)
