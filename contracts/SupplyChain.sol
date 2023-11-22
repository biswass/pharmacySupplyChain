// SPDX-License-Identifier: UNLICENSED
// pragma solidity >=0.4.25 <0.9.0;
// pragma experimental ABIEncoderV2;
pragma solidity >=0.8.0;
pragma abicoder v2;

import "./RawMatrials.sol";
import "./Madicine.sol";
import "./MadicineW_D.sol";
import "./MadicineD_P.sol";
import "./MadicineP_C.sol";
import "./Library.sol";

contract SupplyChain {
    using MyLibrary for MyLibrary.madicineStatus;
    using MyLibrary for MyLibrary.medicineBasicInfo;
    using MyLibrary for MyLibrary.rawMaterialInfo;

    /// @notice
    address public Owner;

    /// @notice
    /// @dev Initiate SupplyChain Contract
    constructor() public {
        Owner = msg.sender;
    }

    /********************************************** Owner Section *********************************************/
    /// @dev Validate Owner
    modifier onlyOwner() {
        require(msg.sender == Owner, "Only owner can call this function.");
        _;
    }

    enum roles {
        norole,
        supplier,
        transporter,
        manufacturer,
        wholesaler,
        distributer,
        pharma,
        customer,
        revoke
    }

    event UserRegister(address indexed EthAddress, bytes32 Name);
    event UserRoleRevoked(
        address indexed EthAddress,
        bytes32 Name,
        uint256 Role
    );
    event UserRoleRessigne(
        address indexed EthAddress,
        bytes32 Name,
        uint256 Role
    );

    /// @notice
    /// @dev Register New user by Owner
    /// @param EthAddress Ethereum Network Address of User
    /// @param Name User name
    /// @param Location User Location
    /// @param Role User Role
    function registerUser(
        address EthAddress,
        bytes32 Name,
        bytes32 Location,
        uint256 Role
    ) public onlyOwner {
        require(
            UsersDetails[EthAddress].role == roles.norole,
            "User Already registered"
        );
        UsersDetails[EthAddress].name = Name;
        UsersDetails[EthAddress].location = Location;
        UsersDetails[EthAddress].ethAddress = EthAddress;
        UsersDetails[EthAddress].role = roles(Role);
        users.push(EthAddress);
        emit UserRegister(EthAddress, Name);
    }

    /// @notice
    /// @dev Revoke users role
    /// @param userAddress User Ethereum Network Address
    function revokeRole(address userAddress) public onlyOwner {
        require(
            UsersDetails[userAddress].role != roles.norole,
            "User not registered"
        );
        emit UserRoleRevoked(
            userAddress,
            UsersDetails[userAddress].name,
            uint256(UsersDetails[userAddress].role)
        );
        UsersDetails[userAddress].role = roles(8);
    }

    /// @notice
    /// @dev Reassigne new role to User
    /// @param userAddress User Ethereum Network Address
    /// @param Role Role to assigne
    function reassigneRole(address userAddress, uint256 Role) public onlyOwner {
        require(
            UsersDetails[userAddress].role != roles.norole,
            "User not registered"
        );
        UsersDetails[userAddress].role = roles(Role);
        emit UserRoleRessigne(
            userAddress,
            UsersDetails[userAddress].name,
            uint256(UsersDetails[userAddress].role)
        );
    }

    /********************************************** User Section **********************************************/
    struct UserInfo {
        bytes32 name;
        bytes32 location;
        address ethAddress;
        roles role;
    }

    mapping(address => UserInfo) UsersDetails;

    address[] users;

    /// @notice
    /// @dev Get User Information/ Profile
    /// @param User User Ethereum Network Address
    /// @return name  Details
    /// @return location  Details
    /// @return ethAddress  Details
    /// @return role  Details
    function getUserInfo(
        address User
    )
        public
        view
        returns (bytes32 name, bytes32 location, address ethAddress, roles role)
    {
        return (
            UsersDetails[User].name,
            UsersDetails[User].location,
            UsersDetails[User].ethAddress,
            UsersDetails[User].role
        );
    }

    /// @notice
    /// @dev Get Number of registered Users
    /// @return count of registered Users
    function getUsersCount() public view returns (uint256 count) {
        return users.length;
    }

    /// @notice
    /// @dev Get User by Index value of stored data
    /// @param index Indexed Number
    /// @return name Details
    /// @return location Details
    /// @return ethAddress Details
    /// @return role Details
    function getUserbyIndex(
        uint256 index
    )
        public
        view
        returns (bytes32 name, bytes32 location, address ethAddress, roles role)
    {
        return getUserInfo(users[index]);
    }

    /********************************************** Supplier Section ******************************************/

    mapping(address => address[]) supplierRawProductInfo;
    event RawSupplyInit(
        address indexed ProductID,
        address indexed Supplier,
        address Shipper,
        address indexed Receiver
    );

    /// @notice
    /// @dev Create new raw package by Supplier
    /// @param Des Transporter Ethereum Network Address
    /// @param Rcvr Manufacturer Ethereum Network Address
    function createRawPackage(
        bytes32 Des,
        bytes32 FN,
        bytes32 Loc,
        uint256 Quant,
        address Shpr,
        address Rcvr
    ) public {
        require(
            UsersDetails[msg.sender].role == roles.supplier,
            "Only Supplier Can call this function "
        );
        RawMatrials rawData = new RawMatrials(
            msg.sender,
            Des,
            FN,
            Loc,
            Quant,
            Shpr,
            Rcvr
        );
        supplierRawProductInfo[msg.sender].push(address(rawData));
        // emit RawSupplyInit(address(rawData), msg.sender, Shpr, Rcvr);
        emit MyLibrary.ShippmentUpdate(
            address(rawData),
            Shpr,
            Rcvr,
            block.timestamp,
            MyLibrary.madicineStatus(0),
            0
        );
    }

    //0 => supplier

    /// @notice
    /// @dev  Get Count of created package by supplier(caller)
    /// @return count of packages
    function getPackagesCountS() public view returns (uint256 count) {
        require(
            UsersDetails[msg.sender].role == roles.supplier,
            "Only Supplier Can call this function "
        );
        return supplierRawProductInfo[msg.sender].length;
    }

    /// @notice
    /// @dev Get PackageID by Indexed value of stored data
    /// @param index Indexed Value
    /// @return packageID
    function getPackageIdByIndexS(
        uint256 index
    ) public view returns (address packageID) {
        require(
            UsersDetails[msg.sender].role == roles.supplier,
            "Only Supplier Can call this function "
        );
        return supplierRawProductInfo[msg.sender][index];
    }

    /********************************************** Transporter Section ******************************************/

    /// @notice
    /// @dev Load Consingment fot transport one location to another.
    /// @param pid PackageID or MadicineID
    /// @param transportertype Transporter Type on the basic of tx between Roles
    /// @param cid Sub Contract ID for Consingment transaction
    function loadConsingment(
        address pid, //Package or Batch ID
        uint256 transportertype,
        address cid
    ) public {
        require(
            UsersDetails[msg.sender].role == roles.transporter,
            "Only Transporter can call this function"
        );
        require(transportertype > 0, "Transporter Type must be define");

        if (transportertype == 1) {
            // Supplier to Manufacturer
            RawMatrials(pid).pickPackage(msg.sender);
            emit MyLibrary.ShippmentUpdate(
                address(pid),
                msg.sender,
                address(0),
                block.timestamp,
                MyLibrary.madicineStatus(1),
                1
            );
        } else if (transportertype == 2) {
            // Manufacturer to Wholesaler OR Manufacturer to Distributer
            Madicine(pid).pickPackage(msg.sender);
            emit MyLibrary.ShippmentUpdate(
                address(pid),
                msg.sender,
                address(0),
                block.timestamp,
                MyLibrary.madicineStatus(1),
                2
            );
        } else if (transportertype == 3) {
            // Wholesaler to Distributer
            MadicineW_D(cid).pickWD(pid, msg.sender);
            emit MyLibrary.ShippmentUpdate(
                address(pid),
                msg.sender,
                address(0),
                block.timestamp,
                MyLibrary.madicineStatus(2),
                3
            );
        } else if (transportertype == 4) {
            // Distrubuter to Pharma
            MadicineD_P(cid).pickDP(pid, msg.sender);
            emit MyLibrary.ShippmentUpdate(
                address(pid),
                msg.sender,
                address(0),
                block.timestamp,
                MyLibrary.madicineStatus(5),
                4
            );
        } else if (transportertype == 5) {
            // Pharma to Customer
            MadicineP_C(cid).pickPC(pid, msg.sender);
            emit MyLibrary.ShippmentUpdate(
                address(pid),
                msg.sender,
                address(0),
                block.timestamp,
                MyLibrary.madicineStatus(7),
                5
            );
        }
    }

    /********************************************** Manufacturer Section ******************************************/

    mapping(address => address[]) RawPackagesAtManufacturer;

    /// @notice
    /// @dev Update Package / Madicine batch recieved status by ethier Manufacturer or Distributer
    /// @param pid  PackageID or MadicineID
    function rawPackageReceived(address pid) public {
        require(
            UsersDetails[msg.sender].role == roles.manufacturer,
            "Only manufacturer can call this function"
        );

        RawMatrials(pid).receivedPackage(msg.sender);
        emit MyLibrary.ShippmentUpdate(
            address(pid),
            address(0),
            msg.sender,
            block.timestamp,
            MyLibrary.madicineStatus(2),
            6
        );
        RawPackagesAtManufacturer[msg.sender].push(pid);
    }

    /// @notice
    /// @dev Get Package Count at Manufacturer
    /// @return count of Packages at Manufacturer
    function getPackagesCountM() public view returns (uint256 count) {
        require(
            UsersDetails[msg.sender].role == roles.manufacturer,
            "Only manufacturer can call this function"
        );
        return RawPackagesAtManufacturer[msg.sender].length;
    }

    /// @notice
    /// @dev Get PackageID by Indexed value of stored data
    /// @param index Indexed Value
    /// @return BatchID
    function getPackageIDByIndexM(
        uint256 index
    ) public view returns (address BatchID) {
        require(
            UsersDetails[msg.sender].role == roles.manufacturer,
            "Only manufacturer can call this function"
        );
        return RawPackagesAtManufacturer[msg.sender][index];
    }

    mapping(address => address[]) ManufactureredMadicineBatches;
    event MadicineNewBatch(
        address indexed BatchId,
        address indexed Manufacturer,
        address shipper,
        address indexed Receiver
    );

    /// @notice
    /// @dev Create Madicine Batch
    /// @param Des Description of madicine batch
    /// @param RM RawMatrials Information
    /// @param Quant Number of Units
    /// @param Shpr Transporter Ethereum Network Address
    /// @param Rcvr Receiver Ethereum Network Address
    /// @param RcvrType Receiver Type Ethier Wholesaler(1) or Distributer(2)
    function manufacturMadicine(
        bytes32 Des,
        bytes32 RM,
        address RawMaterialAddres,
        uint256 Quant,
        address Shpr,
        address Rcvr,
        uint256 RcvrType
    ) public {
        require(
            UsersDetails[msg.sender].role == roles.manufacturer,
            "Only manufacturer can call this function"
        );
        require(RcvrType != 0, "Receiver Type must be define");

        Madicine m = new Madicine(
            msg.sender,
            Des,
            RM,
            RawMaterialAddres,
            Quant,
            Shpr,
            Rcvr,
            RcvrType,
            UsersDetails[msg.sender].location
        );

        ManufactureredMadicineBatches[msg.sender].push(address(m));
        // emit MadicineNewBatch(address(m), msg.sender, Shpr, Rcvr);
        emit MyLibrary.ShippmentUpdate(
            address(m),
            Shpr,
            Rcvr,
            block.timestamp,
            MyLibrary.madicineStatus(0),
            6
        );
    }

    /// @notice
    /// @dev Get Madicine Batch Count
    /// @return count of Batches
    function getBatchesCountM() public view returns (uint256 count) {
        require(
            UsersDetails[msg.sender].role == roles.manufacturer,
            "Only Manufacturer Can call this function."
        );
        return ManufactureredMadicineBatches[msg.sender].length;
    }

    /// @notice
    /// @dev Get Madicine BatchID by indexed value of stored data
    /// @param index Indexed Number
    /// @return packageID Madicine BatchID
    function getBatchIdByIndexM(
        uint256 index
    ) public view returns (address packageID) {
        require(
            UsersDetails[msg.sender].role == roles.manufacturer,
            "Only Manufacturer Can call this function."
        );
        return ManufactureredMadicineBatches[msg.sender][index];
    }

    /********************************************** Wholesaler Section ******************************************/

    mapping(address => address[]) MadicineBatchesAtWholesaler;

    /// @notice
    /// @dev Madicine Batch Received
    /// @param batchid Madicine BatchID
    /// @param cid Sub Contract ID for Madicine (if transaction Wholesaler to Distributer)
    function madicineReceived(address batchid, address cid) public {
        require(
            UsersDetails[msg.sender].role == roles.wholesaler ||
                UsersDetails[msg.sender].role == roles.distributer,
            "Only Wholesaler and Distributer can call this function"
        );

        uint256 rtype = Madicine(batchid).receivedPackage(msg.sender);
        if (UsersDetails[msg.sender].role == roles.wholesaler) {
            emit MyLibrary.ShippmentUpdate(
                address(batchid),
                address(0),
                msg.sender,
                block.timestamp,
                MyLibrary.madicineStatus(3),
                7
            );
        } else {
            emit MyLibrary.ShippmentUpdate(
                address(batchid),
                address(0),
                msg.sender,
                block.timestamp,
                MyLibrary.madicineStatus(4),
                8
            );
        }
        if (rtype == 1) {
            MadicineBatchesAtWholesaler[msg.sender].push(batchid);
        } else if (rtype == 2) {
            MadicineBatchAtDistributer[msg.sender].push(batchid);
            if (Madicine(batchid).getWDP()[0] != address(0)) {
                MadicineW_D(cid).recieveWD(batchid, msg.sender);
                emit MyLibrary.ShippmentUpdate(
                    address(batchid),
                    address(0),
                    msg.sender,
                    block.timestamp,
                    MyLibrary.madicineStatus(4),
                    8
                );
            }
        }
    }

    mapping(address => address[]) MadicineWtoD;

    mapping(address => address) MadicineWtoDTxContract;

    /// @notice
    /// @dev Sub Contract for Madicine Transfer from Wholesaler to Distributer
    /// @param BatchID Madicine BatchID
    /// @param Shipper Transporter Ethereum Network Address
    /// @param Receiver Distributer Ethereum Network Address
    function transferMadicineWtoD(
        address BatchID,
        address Shipper,
        address Receiver
    ) public {
        require(
            UsersDetails[msg.sender].role == roles.wholesaler &&
                msg.sender == Madicine(BatchID).getWDP()[0],
            "Only Wholesaler or current owner of package can call this function"
        );
        MadicineW_D wd = new MadicineW_D(
            BatchID,
            msg.sender,
            Shipper,
            Receiver
        );
        MadicineWtoD[msg.sender].push(address(wd));
        MadicineWtoDTxContract[BatchID] = address(wd);
        emit MyLibrary.ShippmentUpdate(
            BatchID,
            Shipper,
            Receiver,
            block.timestamp,
            MyLibrary.madicineStatus(2),
            9
        );
    }

    /// @notice
    /// @dev Get Madicine Batch Count
    /// @return count of Batches
    function getBatchesCountWD() public view returns (uint256 count) {
        require(
            UsersDetails[msg.sender].role == roles.wholesaler,
            "Only Wholesaler Can call this function."
        );
        return MadicineWtoD[msg.sender].length;
    }

    /// @notice
    /// @dev Get Madicine BatchID by indexed value of stored data
    /// @param index Indexed Number
    /// @return packageID Madicine BatchID
    function getBatchIdByIndexWD(
        uint256 index
    ) public view returns (address packageID) {
        require(
            UsersDetails[msg.sender].role == roles.wholesaler,
            "Only Wholesaler Can call this function."
        );
        return MadicineWtoD[msg.sender][index];
    }

    /// @notice
    /// @dev Get Sub Contract ID of Madicine Batch Transfer in between Wholesaler to Distributer
    /// @param BatchID Madicine BatchID
    /// @return SubContractWD ID
    function getSubContractWD(
        address BatchID
    ) public view returns (address SubContractWD) {
        // require(
        //     UsersDetails[msg.sender].role == roles.wholesaler,
        //     "Only Wholesaler Can call this function."
        // );
        return MadicineWtoDTxContract[BatchID];
    }

    /// @notice
    /// @dev Get Madicine Batch Count
    /// @return count of Batches
    function getBatchesCountW() public view returns (uint256 count) {
        require(
            UsersDetails[msg.sender].role == roles.wholesaler,
            "Only Wholesaler Can call this function."
        );
        return MadicineBatchesAtWholesaler[msg.sender].length;
    }

    /// @notice
    /// @dev Get Madicine BatchID by indexed value of stored data
    /// @param index Indexed Number
    /// @return packageID Madicine BatchID
    function getBatchIdByIndexW(
        uint256 index
    ) public view returns (address packageID) {
        require(
            UsersDetails[msg.sender].role == roles.wholesaler,
            "Only Wholesaler Can call this function."
        );
        return MadicineBatchesAtWholesaler[msg.sender][index];
    }

    /********************************************** Distributer Section ******************************************/

    mapping(address => address[]) MadicineBatchAtDistributer;

    mapping(address => address[]) MadicineDtoP;

    mapping(address => address) MadicineDtoPTxContract;

    /// @notice
    /// @dev Transfer Madicine BatchID in between Distributer to Pharma
    /// @param BatchID Madicine BatchID
    /// @param Shipper Transporter Ethereum Network Address
    /// @param Receiver Pharma Ethereum Network Address
    function transferMadicineDtoP(
        address BatchID,
        address Shipper,
        address Receiver
    ) public {
        require(
            UsersDetails[msg.sender].role == roles.distributer &&
                msg.sender == Madicine(BatchID).getWDP()[1],
            "Only Distributer or current owner of package can call this function"
        );
        MadicineD_P dp = new MadicineD_P(
            BatchID,
            msg.sender,
            Shipper,
            Receiver
        );
        MadicineDtoP[msg.sender].push(address(dp));
        MadicineDtoPTxContract[BatchID] = address(dp);
        emit MyLibrary.ShippmentUpdate(
            BatchID,
            Shipper,
            Receiver,
            block.timestamp,
            MyLibrary.madicineStatus(5),
            10
        );
    }

    /// @notice
    /// @dev Get Madicine BatchID Count
    /// @return count Number of Batches
    function getBatchesCountDP() public view returns (uint256 count) {
        require(
            UsersDetails[msg.sender].role == roles.distributer,
            "Only Distributer Can call this function."
        );
        return MadicineDtoP[msg.sender].length;
    }

    /// @notice
    /// @dev Get Madicine BatchID by indexed value of stored data
    /// @param index Index Number
    /// @return packageID Madicine BatchID
    function getBatchIdByIndexDP(
        uint256 index
    ) public view returns (address packageID) {
        require(
            UsersDetails[msg.sender].role == roles.distributer,
            "Only Distributer Can call this function."
        );
        return MadicineDtoP[msg.sender][index];
    }

    /// @notice
    /// @dev Get SubContract ID of Madicine Batch Transfer in between Distributer to Pharma
    /// @param BatchID Madicine BatchID
    /// @return SubContractDP ID
    function getSubContractDP(
        address BatchID
    ) public view returns (address SubContractDP) {
        // require(
        //     UsersDetails[msg.sender].role == roles.distributer,
        //     "Only Distributer Can call this function."
        // );
        return MadicineDtoPTxContract[BatchID];
    }

    /// @notice
    /// @dev Get Madicine Batch Count
    /// @return count of Batches
    function getBatchesCountD() public view returns (uint256 count) {
        require(
            UsersDetails[msg.sender].role == roles.distributer,
            "Only Distributer can call this function."
        );
        return MadicineBatchAtDistributer[msg.sender].length;
    }

    /// @notice
    /// @dev Get Madicine BatchID by indexed value of stored data
    /// @param index Indexed Number
    /// @return packageID Madicine BatchID
    function getBatchIdByIndexD(
        uint256 index
    ) public view returns (address packageID) {
        require(
            UsersDetails[msg.sender].role == roles.distributer,
            "Only Distributer can call this function."
        );
        return MadicineBatchAtDistributer[msg.sender][index];
    }

    /********************************************** Pharma Section ******************************************/

    mapping(address => address[]) MadicineBatchAtPharma;

    mapping(address => address[]) MadicinePtoC;

    mapping(address => address) MadicinePtoCTxContract;

    /// @notice
    /// @dev Madicine Batch Recieved
    /// @param batchid Madicine BatchID
    /// @param cid SubContract ID
    function madicineRecievedAtPharma(address batchid, address cid) public {
        require(
            UsersDetails[msg.sender].role == roles.pharma,
            "Only Pharma Can call this function."
        );
        MadicineD_P(cid).recieveDP(batchid, msg.sender);
        MadicineBatchAtPharma[msg.sender].push(batchid);
        emit MyLibrary.ShippmentUpdate(
            address(batchid),
            address(0),
            msg.sender,
            block.timestamp,
            MyLibrary.madicineStatus(6),
            11
        );
        sale[batchid] = salestatus(1);
    }

    /// @notice
    /// @dev Transfer Madicine BatchID in between Pharma to Customer
    /// @param BatchID Madicine BatchID
    /// @param Shipper Transporter Ethereum Network Address
    /// @param Receiver Customer Ethereum Network Address
    function transferMadicinePtoC(
        address BatchID,
        address Shipper,
        address Receiver
    ) public {
        require(
            UsersDetails[msg.sender].role == roles.pharma &&
                msg.sender == Madicine(BatchID).getWDP()[2],
            "Only Pharma or current owner of package can call this function"
        );
        MadicineP_C pc = new MadicineP_C(
            BatchID,
            msg.sender,
            Shipper,
            Receiver
        );
        MadicinePtoC[msg.sender].push(address(pc));
        MadicinePtoCTxContract[BatchID] = address(pc);
        emit MyLibrary.ShippmentUpdate(
            BatchID,
            Shipper,
            Receiver,
            block.timestamp,
            MyLibrary.madicineStatus(7),
            12
        );
        updateSaleStatus(BatchID, 2);
    }

    enum salestatus {
        notfound,
        atpharma,
        sold,
        expire,
        damaged
    }

    mapping(address => salestatus) sale;

    event MadicineStatus(
        address BatchID,
        address indexed Pharma,
        uint256 status
    );

    /// @notice
    /// @dev Update Madicine Batch status
    /// @param BatchID Madicine BatchID
    /// @param Status Madicine Batch Status ( sold, expire etc.)
    function updateSaleStatus(address BatchID, uint256 Status) public {
        require(
            UsersDetails[msg.sender].role == roles.pharma &&
                msg.sender == Madicine(BatchID).getWDP()[2],
            "Only Pharma or current owner of package can call this function"
        );
        require(sale[BatchID] == salestatus(1), "madicine Must be at Pharma");
        sale[BatchID] = salestatus(Status);

        emit MadicineStatus(BatchID, msg.sender, Status);
    }

    /// @notice
    /// @dev Get Madicine Batch status
    /// @param BatchID Madicine BatchID
    /// @return Status
    function salesInfo(address BatchID) public view returns (uint256 Status) {
        return uint256(sale[BatchID]);
    }

    /// @notice
    /// @dev Get Madicine BatchID Count
    /// @return count Number of Batches
    function getBatchesCountPC() public view returns (uint256 count) {
        require(
            UsersDetails[msg.sender].role == roles.pharma,
            "Only Pharma can call this function."
        );
        return MadicinePtoC[msg.sender].length;
    }

    /// @notice
    /// @dev Get Madicine BatchID by indexed value of stored data
    /// @param index Index Number
    /// @return packageID Madicine BatchID
    function getBatchIdByIndexPC(
        uint256 index
    ) public view returns (address packageID) {
        require(
            UsersDetails[msg.sender].role == roles.pharma,
            "Only Pharma can call this function."
        );
        return MadicinePtoC[msg.sender][index];
    }

    /// @notice
    /// @dev Get SubContract ID of Madicine Batch Transfer in between Pharma to Customer
    /// @param BatchID Madicine BatchID
    /// @return SubContractPC ID
    function getSubContractPC(
        address BatchID
    ) public view returns (address SubContractPC) {
        // require(
        //     UsersDetails[msg.sender].role == roles.pharma,
        //     "Only Pharma can call this function."
        // );
        return MadicinePtoCTxContract[BatchID];
    }

    /// @notice
    /// @dev Get Madicine Batch count
    /// @return count of Batches
    function getBatchesCountP() public view returns (uint256 count) {
        require(
            UsersDetails[msg.sender].role == roles.pharma,
            "Only Pharma or current owner of package can call this function"
        );
        return MadicineBatchAtPharma[msg.sender].length;
    }

    /// @notice
    /// @dev Get Madicine BatchID by indexed value of stored data
    /// @param index Index Number
    /// @return BatchID
    function getBatchIdByIndexP(
        uint256 index
    ) public view returns (address BatchID) {
        require(
            UsersDetails[msg.sender].role == roles.pharma,
            "Only Pharma or current owner of package can call this function"
        );
        return MadicineBatchAtPharma[msg.sender][index];
    }

    /********************************************** Customer Section ******************************************/

    /// @notice
    /// @dev Madicine Batch Recieved
    /// @param batchid Madicine BatchID
    /// @param cid SubContract ID
    function madicineRecievedByCustomer(address batchid, address cid) public {
        require(
            UsersDetails[msg.sender].role == roles.customer,
            "Only Customer can call this function."
        );
        MadicineP_C(cid).recievePC(batchid, msg.sender);
        emit MyLibrary.ShippmentUpdate(
            address(batchid),
            address(0),
            msg.sender,
            block.timestamp,
            MyLibrary.madicineStatus(8),
            13
        );
    }

    /********************************************** For Everyone ******************************************/

    function getMedicineBatchInfo(
        address batchid
    )
        public
        view
        returns (
            MyLibrary.rawMaterialInfo memory rawMaterialsInfo,
            MyLibrary.medicineBasicInfo memory BasicInfo,
            bytes32 WholesalerLocation,
            bytes32 DistributerLocation,
            bytes32 PharmaLocation
        )
    {
        (
            MyLibrary.medicineBasicInfo memory basic_info,
            address whlslr,
            address dstri,
            address phrm,
            address RMA
        ) = Madicine(batchid).getMadicineInfo();

        return (
            RawMatrials(RMA).getRawInfo(),
            basic_info,
            UsersDetails[whlslr].location,
            UsersDetails[dstri].location,
            UsersDetails[phrm].location
        );
    }
}
