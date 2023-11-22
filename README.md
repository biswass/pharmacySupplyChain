# Blockchain : Pharmacy SupplyChain
This project showcases the journey of Medicine on blockchain.

The Pharmacy supply chain comprises the processes to bring healthcare products from supplier to the customer

To be extended further to customize the mining process, reward mechanism and concensus algorithm

Currently deployed at https://sepolia.etherscan.io/address/0x70754B825f031f1aCF2666adE3A902546596042c

#### Problems in Existing System
---
- Considerable paperwork
- Malicous activities eg: expiry date manufacturing
- Delayed status of shipment
- Communication between stakeholders
- Lack of transperancy due to resource transperancy

#### What we are providing
---
- Minimal paperwork
- Immutable data
- Real time tracking of shipments
- Synchronization between participants
- Transparent process

#### Roles
---
1. Admin
2. Supplier
3. Transporter
4. Manufacturer
5. Wholesaler
6. Distributer
7. Pharma
8. Customer

**Admin :** Register users and allocates roles
**Supplier :** Supplies raw materials manufacturer by creating new batch with details
**Transporter :** Ship packages between stages
**Manufacturer :** Manufacturers new medicine batches for shipping to either Wholesaler/Distributor, by updating information of raw materials details, used to manufacture new batch medicine and quantity
**Wholesaler :** Receives medicine from manufacturer and validates medicine quality, transfers to Distributer
**Distributer :** Distributes medicne to pharmacy and verifies medicine quality and condition
**Pharma :** Provides medicine to customer as per prescription and updates medicine status
**Customer :** Tracks medicine details and status

#### Tools and Technologies
---
- Solidity (Ethereum's Smart Contract Language)
- Metamask (Ethereum wallet)
- Sepolia Test network 
- Truffle
- Infura
- Web3JS
- AngularJS

#### Prerequisites
---
- Nodejs v16.14.0 or above
- Truffle v5.11.5 (core: 5.11.5)
- Solidity v0.5.1
- Ganache
- Metamask 
- Web3.js v1.10.0

#### Deployment:
- truffle compile // compiles the contracts
- truffle migrate --network sepolia reset // deploys the compiled contract on sepolia test network
- truffle console --network sepolia // Login to the truffle console
- storage = await SupplyChain.deployed()  // Shows the deployed contract
- truffle(sepolia)> storage.address // You got it right, if it prints your contract address in hex as below
'0xf0790374F2f06355cD599BcF6f6Eff871241c32B'
- storage.registerUser(walletAddress, name, rplace)
eg : storage.registerUser('0x2E1eBC8FB7D358DC538e556a8D6683B48d64007C','0x426973776173','0x42656e67616c757275',0) // (parameter1 - wallet address), Biswas(parameter2 - name in hex), Bengaluru(parameter3 - place in hex), 2(parameter4 - admin's role id)
- Similarly, registered for below roles
(wallet address), Subhramit, Kolkata, 1(supplierRoleId)
(wallet address), Ohiduz, Kohima, 2(transporterRoleId)
(wallet address), Maddy, Trivandrum, 3(manufacturerRoleId)
(wallet address), Sanshav, Delhi, 4(distributerRoleId)
(wallet address), Alice, Antartica, 5(pharmaRoleId)
(wallet address), Bob, Greenland, 6(customerRoleId)
- Now sign in via the supplier role - In truffle-config.js, return new HDWalletProvider(mnemonic, "https://sepolia.infura.io/v3/"+infuraKey, 1)
and relogin to the truffle console(truffle console --network sepolia)
- Create a raw package as the supplier. Command - storage.createRawPackage('0x50617261636574616d6f6c','0x4661726d65722052616d','0x47756a61726174',10,'0x2E1eBC8FB7D358DC538e556a8D6683B48d64007C','0xCAb6ebc4d56B8391251d16eA7f559d15D8C2B827')

#### Supply Chain Contract Business Logic:
- truffle console --network sepolia // connects to the sepolia network
- truffle(sepolia)> storage = await SupplyChain.deployed() // stores the contract address in 
- Created 7 different users, 1 per role
- Created 3 packages(1 each of 3 products mentioned on Products page) and moved around in different phases of supply chain
- Track each of them via the status page http://localhost:3000/Status


#### Contract Deployment Steps:
---
**Setting up Ethereum Smart Contract:**

```
git clone https://github.com/biswass/Blockchain_SupplyChain.git
cd Blockchain_SupplyChain/
```
**Update truffle.js **

```
module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    sepolia: {
      provider: function() {
        var mnemonic = "";   //put ETH wallet 12 mnemonic code
        return new HDWalletProvider(mnemonic, "https://sepolia.infura.io/v3/"+infuraKey, 1); 
      },
      gas: 8000000, 
      gasPrice: 60000000000, 
      network_id: '11155111', 
    }
  }
}

```
Go to your project folder in terminal then execute :

```
rm -rf build/
truffle compile
truffle migrate --network sepolia reset
```
**Please note:**
1. After successfully deployment you will get response in bash terminal like below
```
Starting migrations...
======================
> Network name:    'sepolia'
> Network id:      11155111
> Block gas limit: 30000000 (0x1c9c380)


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > transaction hash:    0x3caffb9ccef50c7ba2a4d712c0ba49fa50522adf0792e8fdf74d411e0dd52922
   > Blocks: 2            Seconds: 17
   > contract address:    0xE024d6F98F637710459346662C05C4184c32e938
   > block number:        4687523
   > block timestamp:     1699903344
   > account:             0x262e4BBd3dCBb26d41e82F5ebb8B261A82B40151
   > balance:             1.20055638
   > gas used:            204443 (0x31e9b)
   > gas price:           60 gwei
   > value sent:          0 ETH
   > total cost:          0.01226658 ETH

   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.01226658 ETH


2_deploy_supplychain.js
=======================
[ '0x262e4BBd3dCBb26d41e82F5ebb8B261A82B40151' ]

   Deploying 'SupplyChain'
   -----------------------
   > transaction hash:    0x55493fec083a5b1438f9c21645953d2540c191e86bce4d22df7fe35db2749b62
   > Blocks: 2            Seconds: 17
   > contract address:    0x7808777C0505ba26460fD7Ce5A25F373Fb5dBA0e
   > block number:        4687526
   > block timestamp:     1699903380
   > account:             0x262e4BBd3dCBb26d41e82F5ebb8B261A82B40151
   > balance:             0.96100752
   > gas used:            3946812 (0x3c393c)
   > gas price:           60 gwei
   > value sent:          0 ETH
   > total cost:          0.23680872 ETH

   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.23680872 ETH

Summary
=======
> Total deployments:   2
> Final cost:          0.2490753 ETH

```

#### Pharmacy Supply Chain Frontend:
---
**Set up Frontend:**

```
cd client
npm install
cd components -> Go to DisplayProduct.js and DisplayStatus.js -> update const ContractAddress = <deployedSmartContractAddress>
cd .. // Goes back to client folder
npm start
Check http://localhost:3000/ to run the application. Go to the status tab and search for 0x5963339cB935082c3f63f25ecF487A90605eA8bc(raw material) and 0xBBe540a810D581c09c4458EE40D7790e18F6BF3F(medicine). You should see the below pages :

![alt text](https://github.com/biswass/pharmacySupplyChain/blob/sanshrav1311-patch-2/assets/flow/medicine.png)

![alt text](https://github.com/biswass/pharmacySupplyChain/blob/sanshrav1311-patch-2/assets/flow/status.png)


 ```
