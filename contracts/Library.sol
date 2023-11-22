// SPDX-License-Identifier: UNLICENSED
// pragma solidity >=0.4.25 <0.9.0;
pragma solidity >=0.8.0;
pragma abicoder v2;

library MyLibrary {
    enum madicineStatus {
        atcreator,
        picked4W,
        picked4D,
        deliveredatW,
        deliveredatD,
        picked4P,
        deliveredatP,
        picked4C,
        deliveredatC
    }
    //0 => supplier created

    //// load consignement transporter
    //1 => in transit sup to manu
    //2 in transit Manufacturer to Wholesaler OR Manufacturer to Distributer
    //3 in transit Wholesaler to Distributer
    //4 in transit Distrubuter to Pharma
    //5 in transit Pharma to Customer
    /////

    //6 received Manufacturer madicine
    //7 received by wholesaler
    //8 recived by distributor
    //9 pickup scheduled at wholesaler to D
    //10 piickup scheduled at distributor to pharma
    //11 recieved at Pharma
    //12 pickup scheduled at Pharma to Costumor
    //13 recevied by customer

    //14 manufactuer medacine

    struct medicineBasicInfo {
        bytes32 Description;
        bytes32 RawMaterials;
        uint256 ManufacturingTime;
        uint256 ExpiryTime;
        bytes32 ManufacturingLocation;
        uint256 QualityCheckTime;
        uint256 ArrivalTimeAtWholesaler;
        uint256 ArrivalTimeAtDistributer;
        uint256 ArrivalTimeAtPharma;
        uint256 SaleTime;
        madicineStatus Status;
    }
    struct rawMaterialInfo {
        bytes32 farmer_name;
        bytes32 farm_location;
        uint256 RawMaterialArrivalTimeAtManufacturer;
    }
    event ShippmentUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Receiver,
        uint timestamp,
        MyLibrary.madicineStatus status,
        uint8 packageStatus
    );
}
