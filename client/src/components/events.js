//step 1: run npm install web3
//step 1.5: add line this line in package.json => "type": "module"
//step 2: add infura api key(or any other rpc end point)
//step 3: add contract address of supplychain.sol
//step 4: change variable ADD to input address of package
//step 5: run code
//import Web3 from "web3";
const { Web3 } = require("web3");
//const Web3 = require("web3");
const web3 = new Web3(
  "https://sepolia.infura.io/v3/02b787ae4676470baac9ea2288b785d5"
); //step 2
const ABI = JSON.parse(`[
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "BatchId",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "Manufacturer",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "shipper",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "Receiver",
				"type": "address"
			}
		],
		"name": "MadicineNewBatch",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "Pharma",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "status",
				"type": "uint256"
			}
		],
		"name": "MadicineStatus",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "ProductID",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "Supplier",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "Shipper",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "Receiver",
				"type": "address"
			}
		],
		"name": "RawSupplyInit",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "Shipper",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "Receiver",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "enum MyLibrary.madicineStatus",
				"name": "status",
				"type": "uint8"
			},
			{
				"indexed": false,
				"internalType": "uint8",
				"name": "packageStatus",
				"type": "uint8"
			}
		],
		"name": "ShippmentUpdate",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "EthAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "bytes32",
				"name": "Name",
				"type": "bytes32"
			}
		],
		"name": "UserRegister",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "EthAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "bytes32",
				"name": "Name",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "Role",
				"type": "uint256"
			}
		],
		"name": "UserRoleRessigne",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "EthAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "bytes32",
				"name": "Name",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "Role",
				"type": "uint256"
			}
		],
		"name": "UserRoleRevoked",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "Owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "Des",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "FN",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "Loc",
				"type": "bytes32"
			},
			{
				"internalType": "uint256",
				"name": "Quant",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "Shpr",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "Rcvr",
				"type": "address"
			}
		],
		"name": "createRawPackage",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getBatchIdByIndexD",
		"outputs": [
			{
				"internalType": "address",
				"name": "packageID",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getBatchIdByIndexDP",
		"outputs": [
			{
				"internalType": "address",
				"name": "packageID",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getBatchIdByIndexM",
		"outputs": [
			{
				"internalType": "address",
				"name": "packageID",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getBatchIdByIndexP",
		"outputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getBatchIdByIndexPC",
		"outputs": [
			{
				"internalType": "address",
				"name": "packageID",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getBatchIdByIndexW",
		"outputs": [
			{
				"internalType": "address",
				"name": "packageID",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getBatchIdByIndexWD",
		"outputs": [
			{
				"internalType": "address",
				"name": "packageID",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBatchesCountD",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBatchesCountDP",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBatchesCountM",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBatchesCountP",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBatchesCountPC",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBatchesCountW",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBatchesCountWD",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "batchid",
				"type": "address"
			}
		],
		"name": "getMedicineBatchInfo",
		"outputs": [
			{
				"components": [
					{
						"internalType": "bytes32",
						"name": "farmer_name",
						"type": "bytes32"
					},
					{
						"internalType": "bytes32",
						"name": "farm_location",
						"type": "bytes32"
					},
					{
						"internalType": "uint256",
						"name": "RawMaterialArrivalTimeAtManufacturer",
						"type": "uint256"
					}
				],
				"internalType": "struct MyLibrary.rawMaterialInfo",
				"name": "rawMaterialsInfo",
				"type": "tuple"
			},
			{
				"components": [
					{
						"internalType": "bytes32",
						"name": "Description",
						"type": "bytes32"
					},
					{
						"internalType": "bytes32",
						"name": "RawMaterials",
						"type": "bytes32"
					},
					{
						"internalType": "uint256",
						"name": "ManufacturingTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "ExpiryTime",
						"type": "uint256"
					},
					{
						"internalType": "bytes32",
						"name": "ManufacturingLocation",
						"type": "bytes32"
					},
					{
						"internalType": "uint256",
						"name": "QualityCheckTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "ArrivalTimeAtWholesaler",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "ArrivalTimeAtDistributer",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "ArrivalTimeAtPharma",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "SaleTime",
						"type": "uint256"
					},
					{
						"internalType": "enum MyLibrary.madicineStatus",
						"name": "Status",
						"type": "uint8"
					}
				],
				"internalType": "struct MyLibrary.medicineBasicInfo",
				"name": "BasicInfo",
				"type": "tuple"
			},
			{
				"internalType": "bytes32",
				"name": "WholesalerLocation",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "DistributerLocation",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "PharmaLocation",
				"type": "bytes32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getPackageIDByIndexM",
		"outputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getPackageIdByIndexS",
		"outputs": [
			{
				"internalType": "address",
				"name": "packageID",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPackagesCountM",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPackagesCountS",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			}
		],
		"name": "getSubContractDP",
		"outputs": [
			{
				"internalType": "address",
				"name": "SubContractDP",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			}
		],
		"name": "getSubContractPC",
		"outputs": [
			{
				"internalType": "address",
				"name": "SubContractPC",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			}
		],
		"name": "getSubContractWD",
		"outputs": [
			{
				"internalType": "address",
				"name": "SubContractWD",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "User",
				"type": "address"
			}
		],
		"name": "getUserInfo",
		"outputs": [
			{
				"internalType": "bytes32",
				"name": "name",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "location",
				"type": "bytes32"
			},
			{
				"internalType": "address",
				"name": "ethAddress",
				"type": "address"
			},
			{
				"internalType": "enum SupplyChain.roles",
				"name": "role",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "index",
				"type": "uint256"
			}
		],
		"name": "getUserbyIndex",
		"outputs": [
			{
				"internalType": "bytes32",
				"name": "name",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "location",
				"type": "bytes32"
			},
			{
				"internalType": "address",
				"name": "ethAddress",
				"type": "address"
			},
			{
				"internalType": "enum SupplyChain.roles",
				"name": "role",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getUsersCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "count",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "pid",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "transportertype",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "cid",
				"type": "address"
			}
		],
		"name": "loadConsingment",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "batchid",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "cid",
				"type": "address"
			}
		],
		"name": "madicineReceived",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "batchid",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "cid",
				"type": "address"
			}
		],
		"name": "madicineRecievedAtPharma",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "batchid",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "cid",
				"type": "address"
			}
		],
		"name": "madicineRecievedByCustomer",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "Des",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "RM",
				"type": "bytes32"
			},
			{
				"internalType": "address",
				"name": "RawMaterialAddres",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "Quant",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "Shpr",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "Rcvr",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "RcvrType",
				"type": "uint256"
			}
		],
		"name": "manufacturMadicine",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "pid",
				"type": "address"
			}
		],
		"name": "rawPackageReceived",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "Role",
				"type": "uint256"
			}
		],
		"name": "reassigneRole",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "EthAddress",
				"type": "address"
			},
			{
				"internalType": "bytes32",
				"name": "Name",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "Location",
				"type": "bytes32"
			},
			{
				"internalType": "uint256",
				"name": "Role",
				"type": "uint256"
			}
		],
		"name": "registerUser",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			}
		],
		"name": "revokeRole",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			}
		],
		"name": "salesInfo",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "Status",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "Shipper",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "Receiver",
				"type": "address"
			}
		],
		"name": "transferMadicineDtoP",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "Shipper",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "Receiver",
				"type": "address"
			}
		],
		"name": "transferMadicinePtoC",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "Shipper",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "Receiver",
				"type": "address"
			}
		],
		"name": "transferMadicineWtoD",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "BatchID",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "Status",
				"type": "uint256"
			}
		],
		"name": "updateSaleStatus",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]`);
const CONTRACT_ADDRESS = "0x70754B825f031f1aCF2666adE3A902546596042c"; //step 3
const myContract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);
const ADD = "0x24A3bA51771514351fdc67cE80d00cf45CD95751";
let options = {
  filter: {},
  fromBlock: 4732900,
  toBlock: "latest",
};
function getInfo(ADD) {
  myContract
    .getPastEvents("ShippmentUpdate", options)
    .then((results) => {
      for (let i = 0; i < results.length; i++) {
        if (results[i].returnValues["0"] == ADD) console.log(results[i]);
      }
    })
    .catch();
}
getInfo(ADD);

const getInfo1 = (ADD) => {
  return myContract
    .getPastEvents("ShippmentUpdate", options)
    .then((results) => {
      const resultList = [];
      for (let i = 0; i < results.length; i++) {
        if (results[i].returnValues["0"] == ADD) {
          resultList.push(results[i]);
          console.log(results[i]);
        }
      }
      return resultList;
    })
    .catch();
};

module.exports = { getInfo1 };
