// SPDX-License-Identifier: UNLICENSED
// pragma solidity >=0.4.25 <0.9.0;
// pragma experimental ABIEncoderV2;
pragma solidity >=0.8.0;
pragma abicoder v2;

import "./Library.sol";

/********************************************** Madicine ******************************************/

contract Madicine {
    using MyLibrary for MyLibrary.madicineStatus;
    using MyLibrary for MyLibrary.medicineBasicInfo;

    address Owner;

    uint256 quantity;
    address shipper;
    address manufacturer;
    address wholesaler;
    address distributer;
    address pharma;
    address customer;
    address rawmaterialAddress;
    MyLibrary.medicineBasicInfo basicInfo;

    // event ShippmentUpdate(
    //     address indexed BatchID,
    //     address indexed Shipper,
    //     address indexed Receiver,
    //     uint256 TransporterType,
    //     uint256 Status
    // );

    /// @notice
    /// @dev Create new Madicine Batch by Manufacturer
    /// @param Manu Manufacturer Ethereum Network Address
    /// @param Des Description of Madicine Batch
    /// @param RM RawMatrials for Madicine
    /// @param Quant Number of units
    /// @param Shpr Transporter Ethereum Network Address
    /// @param Rcvr Receiver Ethereum Network Address
    /// @param RcvrType Receiver Type either Wholesaler(1) or Distributer(2)
    constructor(
        address Manu,
        bytes32 Des,
        bytes32 RM,
        address RMA,
        uint256 Quant,
        address Shpr,
        address Rcvr,
        uint256 RcvrType,
        bytes32 manu_loc
    ) public {
        Owner = Manu;
        manufacturer = Manu;
        basicInfo.Description = Des;
        basicInfo.RawMaterials = RM;
        rawmaterialAddress = RMA;

        quantity = Quant;
        shipper = Shpr;
        basicInfo.ManufacturingLocation = manu_loc;
        basicInfo.ManufacturingTime = block.timestamp;
        basicInfo.ExpiryTime = block.timestamp + (365 days);
        basicInfo.QualityCheckTime = block.timestamp;
        if (RcvrType == 1) {
            wholesaler = Rcvr;
        } else if (RcvrType == 2) {
            distributer = Rcvr;
        }
        // emit MyLibrary.ShippmentUpdate(
        //     address(this),
        //     Shpr,
        //     Rcvr,
        //     1,
        //     MyLibrary.madicineStatus(0)
        // );
    }

    /// @notice
    /// @dev Get Madicine Batch basic Details
    /// @return BasicInfo Details
    /// @return Wholesaler Details
    /// @return Distributer Details
    /// @return Pharma Details
    function getMadicineInfo()
        public
        view
        returns (
            MyLibrary.medicineBasicInfo memory BasicInfo,
            address Wholesaler,
            address Distributer,
            address Pharma,
            address RMA
        )
    {
        return (basicInfo, wholesaler, distributer, pharma, rawmaterialAddress);
    }

    /// @notice
    /// @dev Get address Wholesaler, Distributer and Pharma
    /// @return WDP Address Array
    function getWDP() public view returns (address[4] memory WDP) {
        return ([wholesaler, distributer, pharma, customer]);
    }

    /// @notice
    /// @dev Get Madicine Batch Transaction Status
    /// @return Madicine Transaction Status
    function getBatchIDStatus() public view returns (uint256) {
        return uint256(basicInfo.Status);
    }

    /// @notice
    /// @dev Pick Madicine Batch by Associate Transporter
    /// @param shpr Transporter Ethereum Network Address
    function pickPackage(address shpr) public {
        require(
            shpr == shipper,
            "Only Associate Shipper can call this function"
        );
        require(
            basicInfo.Status == MyLibrary.madicineStatus(0),
            "Package must be at Supplier."
        );

        if (wholesaler != address(0x0)) {
            basicInfo.Status = MyLibrary.madicineStatus(1);
            // emit MyLibrary.ShippmentUpdate(
            //     address(this),
            //     shipper,
            //     wholesaler,
            //     1,
            //     MyLibrary.madicineStatus(1)
            // );
        } else {
            basicInfo.Status = MyLibrary.madicineStatus(2);
            // emit MyLibrary.ShippmentUpdate(
            //     address(this),
            //     shipper,
            //     distributer,
            //     1,
            //     MyLibrary.madicineStatus(2)
            // );
        }
    }

    /// @notice
    /// @dev Received Madicine Batch by Associated Wholesaler or Distributer
    /// @param Rcvr Wholesaler or Distributer
    function receivedPackage(address Rcvr) public returns (uint256 rcvtype) {
        require(
            Rcvr == wholesaler || Rcvr == distributer,
            "Only Associate Wholesaler or Distrubuter can call this function"
        );

        require(uint256(basicInfo.Status) >= 1, "Product not picked up yet");

        if (
            Rcvr == wholesaler &&
            basicInfo.Status == MyLibrary.madicineStatus(1)
        ) {
            basicInfo.Status = MyLibrary.madicineStatus(3);
            basicInfo.ArrivalTimeAtWholesaler = block.timestamp;
            // emit MyLibrary.ShippmentUpdate(
            //     address(this),
            //     shipper,
            //     wholesaler,
            //     2,
            //     MyLibrary.madicineStatus(3)
            // );
            return 1;
        } else if (
            Rcvr == distributer &&
            basicInfo.Status == MyLibrary.madicineStatus(2)
        ) {
            basicInfo.Status = MyLibrary.madicineStatus(4);
            basicInfo.ArrivalTimeAtDistributer = block.timestamp;
            // emit MyLibrary.ShippmentUpdate(
            //     address(this),
            //     shipper,
            //     distributer,
            //     3,
            //     MyLibrary.madicineStatus(4)
            // );
            return 2;
        }
    }

    /// @notice
    /// @dev Update Madicine Batch transaction Status(Pick) in between Wholesaler and Distributer
    /// @param receiver Distributer Ethereum Network Address
    /// @param sender Wholesaler Ethereum Network Address
    function sendWD(address receiver, address sender) public {
        require(wholesaler == sender, "this Wholesaler is not Associated.");
        distributer = receiver;
        basicInfo.Status = MyLibrary.madicineStatus(2);
        // emit MyLibrary.ShippmentUpdate(
        //     address(this),
        //     sender,
        //     receiver,
        //     3,
        //     MyLibrary.madicineStatus(2)
        // );
    }

    /// @notice
    /// @dev Update Madicine Batch transaction Status(Recieved) in between Wholesaler and Distributer
    /// @param receiver Distributer
    function recievedWD(address receiver) public {
        require(distributer == receiver, "This Distributer is not Associated.");
        basicInfo.Status = MyLibrary.madicineStatus(4);
        basicInfo.ArrivalTimeAtDistributer = block.timestamp;
        // emit MyLibrary.ShippmentUpdate(
        //     address(this),
        //     shipper,
        //     receiver,
        //     2,
        //     MyLibrary.madicineStatus(4)
        // );
    }

    /// @notice
    /// @dev Update Madicine Batch transaction Status(Pick) in between Distributer and Pharma
    /// @param receiver Pharma Ethereum Network Address
    /// @param sender Distributer Ethereum Network Address
    function sendDP(address receiver, address sender) public {
        require(distributer == sender, "this Distributer is not Associated.");
        pharma = receiver;
        basicInfo.Status = MyLibrary.madicineStatus(5);
        // emit MyLibrary.ShippmentUpdate(
        //     address(this),
        //     sender,
        //     receiver,
        //     4,
        //     MyLibrary.madicineStatus(5)
        // );
    }

    /// @notice
    /// @dev Update Madicine Batch transaction Status(Recieved) in between Distributer and Pharma
    /// @param receiver Pharma Ethereum Network Address
    function recievedDP(address receiver) public {
        require(pharma == receiver, "This Pharma is not Associated.");
        basicInfo.Status = MyLibrary.madicineStatus(6);
        basicInfo.ArrivalTimeAtPharma = block.timestamp;
        // emit MyLibrary.ShippmentUpdate(
        //     address(this),
        //     shipper,
        //     receiver,
        //     3,
        //     MyLibrary.madicineStatus(6)
        // );
    }

    /// @notice
    /// @dev Update Madicine Batch transaction Status(Pick) in between Pharma and Customer
    /// @param receiver Customer Ethereum Network Address
    /// @param sender Pharma Ethereum Network Address
    function sendPC(address receiver, address sender) public {
        require(pharma == sender, "this Pharma is not Associated.");
        customer = receiver;
        basicInfo.Status = MyLibrary.madicineStatus(7);
        // emit MyLibrary.ShippmentUpdate(
        //     address(this),
        //     sender,
        //     receiver,
        //     5,
        //     MyLibrary.madicineStatus(7)
        // );
    }

    /// @notice
    /// @dev Update Madicine Batch transaction Status(Recieved) in between Pharma and Customer
    /// @param receiver Customer Ethereum Network Address
    function recievedPC(address receiver) public {
        require(customer == receiver, "This Customer is not Associated.");
        basicInfo.Status = MyLibrary.madicineStatus(8);
        basicInfo.SaleTime = block.timestamp;
        // emit MyLibrary.ShippmentUpdate(
        //     address(this),
        //     shipper,
        //     receiver,
        //     4,
        //     MyLibrary.madicineStatus(8)
        // );
    }
}
