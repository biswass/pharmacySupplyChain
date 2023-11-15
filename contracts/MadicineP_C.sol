// SPDX-License-Identifier: UNLICENSED
// pragma solidity >=0.4.25 <0.9.0;
pragma solidity >=0.8.0;
pragma abicoder v2;

import './Madicine.sol';

/********************************************** MadicineP_C ******************************************/

contract MadicineP_C {
    address Owner;

    enum packageStatus { atcreator, picked, delivered}

    address batchid;
    address sender;
    address shipper;
    address receiver;
    packageStatus status;

    /// @notice
    /// @dev Create SubContract for Madicine Transaction
    /// @param BatchID Madicine BatchID
    /// @param Sender Pharma Ethereum Network Address
    /// @param Shipper Transporter Ethereum Network Address
    /// @param Receiver Customer Ethereum Network Address
    constructor(
        address BatchID,
        address Sender,
        address Shipper,
        address Receiver
    ) public {
        Owner = Sender;
        batchid = BatchID;
        sender = Sender;
        shipper = Shipper;
        receiver = Receiver;
        status = packageStatus(0);
    }

    /// @notice
    /// @dev Pick Madicine Batch by Associated Transporter
    /// @param BatchID Madicine BatchID
    /// @param Shipper Transporter Ethereum Network Address
    function pickPC(
        address BatchID,
        address Shipper
    ) public {
        require(
            Shipper == shipper,
            "Only Associated shipper can call this function."
        );
        status = packageStatus(1);

        Madicine(BatchID).sendPC(
            receiver,
            sender
        );
    }

    /// @notice
    /// @dev Recieved Madicine Batch by Associate Customer
    /// @param BatchID Madicine BatchID
    /// @param Receiver Pharma Ethereum Network Address
    function recievePC(
        address BatchID,
        address Receiver
    ) public {
        require(
            Receiver == receiver,
            "Only Associated receiver can call this function."
        );
        status = packageStatus(2);

        Madicine(BatchID).recievedPC(
            Receiver
        );
    }

    /// @notice
    /// @dev Get Madicine Batch Transaction status in between Pharma and Customer
    /// @return Transaction status
    function getBatchIDStatus() public view returns(
        uint256
    ) {
        return uint256(status);
    }

}
