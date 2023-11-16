pragma solidity >=0.4.25 <0.9.0;

import "./Library.sol";

/********************************************** RawMatrials ******************************************/

contract RawMatrials {
    /// @notice
    address Owner;

    enum packageStatus {
        atcreator,
        picked,
        delivered
    }
    // event MyLibrary.ShippmentUpdate(
    //     address indexed BatchID,
    //     address indexed Shipper,
    //     address indexed Manufacturer,
    //     uint TransporterType,
    //     uint Status
    // );
    /// @notice
    address productid;
    /// @notice
    bytes32 description;
    /// @notice
    bytes32 farmer_name;
    /// @notice
    bytes32 location;
    /// @notice
    uint quantity;
    /// @notice
    address shipper;
    /// @notice
    address manufacturer;
    /// @notice
    address supplier;
    /// @notice
    packageStatus status;
    /// @notice
    bytes32 packageReceiverDescription;

    /// @notice
    /// @dev Intiate New Package of RawMatrials by Supplier
    /// @param Splr Supplier Ethereum Network Address
    /// @param Des Description of RawMatrials
    /// @param FN Farmer Name
    /// @param Loc Farm Location
    /// @param Quant Number of units in a package
    /// @param Shpr Transporter Ethereum Network Address
    /// @param Rcvr Manufacturer Ethereum Network Address
    constructor(
        address Splr,
        bytes32 Des,
        bytes32 FN,
        bytes32 Loc,
        uint Quant,
        address Shpr,
        address Rcvr
    ) public {
        Owner = Splr;
        productid = address(this);
        description = Des;
        farmer_name = FN;
        location = Loc;
        quantity = Quant;
        shipper = Shpr;
        manufacturer = Rcvr;
        supplier = Splr;
        status = packageStatus(0);
        emit MyLibrary.ShippmentUpdate(
            address(this),
            Shpr,
            Rcvr,
            1,
            MyLibrary.madicineStatus(0)
        );
    }

    /// @notice
    /// @dev Get RawMatrials Package Details
    /// @return Des Details
    /// @return FN Details
    /// @return Loc Details
    /// @return Quant Details
    /// @return Shpr Details
    /// @return Rcvr Details
    /// @return Splr Details
    function getSuppliedRawMatrials()
        public
        view
        returns (
            bytes32 Des,
            bytes32 FN,
            bytes32 Loc,
            uint Quant,
            address Shpr,
            address Rcvr,
            address Splr
        )
    {
        return (
            description,
            farmer_name,
            location,
            quantity,
            shipper,
            manufacturer,
            supplier
        );
    }

    /// @notice
    /// @dev Get Package Transaction Status
    /// @return Package Status
    function getRawMatrialsStatus() public view returns (uint) {
        return uint(status);
    }

    /// @notice
    /// @dev Pick Package by Associate Transporter
    /// @param shpr Transporter Ethereum Network Address
    function pickPackage(address shpr) public {
        require(
            shpr == shipper,
            "Only Associate Shipper can call this function"
        );
        require(status == packageStatus(0), "Package must be at Supplier.");
        status = packageStatus(1);
        emit MyLibrary.ShippmentUpdate(
            address(this),
            shipper,
            manufacturer,
            1,
            MyLibrary.madicineStatus(1)
        );
    }

    /// @notice
    /// @dev Received Package Status Update By Associated Manufacturer
    /// @param manu Manufacturer Ethereum Network Address
    function receivedPackage(address manu) public {
        require(
            manu == manufacturer,
            "Only Associate Manufacturer can call this function"
        );

        require(status == packageStatus(1), "Product not picked up yet");
        status = packageStatus(2);
        emit MyLibrary.ShippmentUpdate(
            address(this),
            shipper,
            manufacturer,
            1,
            MyLibrary.madicineStatus(2)
        );
    }
}
