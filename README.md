# solidity-exchange-smart-contract

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
