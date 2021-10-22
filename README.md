# Welcome!

## An Intro to The BlocksForEarth Project
The goal of BlocksForEarth is to become an NFT Marketplace for wellness and conservation where users can purchase and sell NFTs and engage in a community. The website that is currently in development will enable users to create an account on the Flow Blockchain with the Blocto wallet provider, allowing them to buy and sell NFTs on the Flow blockchain using FUSD, Flow’s USD-backed stablecoin. 

## Cadence Files
The Bfe-Cadenec repository contains all of our Cadence files, which are files ending in ".cdc". Cadence is the smart contract language on Flow. ‍These Cadence files are either contracts, transactions, or scripts. 

### Contracts
Contracts lay the foundation for resources on Flow, and must be deployed by an account. Almost everything in Cadence must be first defined in a contract (data, functions, and composite types like structs, resources, events, and interfaces for these types in Cadence). Contracts can only be created, updated, and removed by authorized users, typically the person who first deploys the contract. When deployed, anything initialized in a contract is stored to the deployer's account storage. [More on Contracts here.](https://docs.onflow.org/cadence/language/contracts/)

### Transactions
Transactions are objects that are signed by one or more accounts and are sent to the chain to interact with it. There are four optional main phases in a transaction: Preparation, preconditions, execution, and postconditions, in that order. The preparation and execution phases are blocks of code that execute sequentially. [More on Transactions here.](https://docs.onflow.org/cadence/language/transactions/)

### Scripts
Scripts are read-only functions that can return information about resources on the Flow blockchain.

### Coding in Cadence
One thing that takes some getting used to in Cadence is syntax using a backward pointing arrow. Flow is a resource-based language. To prevent errors and minimize security risk, all resources in Flow can only exist in one place at any given time. The architecture of the Flow blockchain and Cadence work harmoniously to make that happen. While the difference in syntax takes time to learn, the resource model used by Flow is quite sophisticated and has the potential to improve experience for end-users.

