pragma solidity >=0.4.25 <0.9.0;

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
        uint ManufacturingTime;
        bytes32 ManufacturingLocation;
        uint QualityCheckTime;
        madicineStatus Status;
    }

    event ShippmentUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Receiver,
        uint TransporterType,
        MyLibrary.madicineStatus status
        // uint timestamp
    );
}
