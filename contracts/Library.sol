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
        MyLibrary.madicineStatus status
    );
}
