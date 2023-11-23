import * as React from 'react';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell, { tableCellClasses } from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import CircularProgress from '@mui/material/CircularProgress';
import Box from '@mui/material/Box';
import { BrowserRouter, Routes, Route, Switch } from "react-router-dom";
import { useState } from "react";
import { ethers } from "ethers";
import SupplyChain from "../artifacts/contracts/SupplyChain.sol/Supplychain.json";
import { styled } from '@mui/material/styles';

const StyledTableCell = styled(TableCell)(({ theme }) => ({
    [`&.${tableCellClasses.head}`]: {
        backgroundColor: theme.palette.common.black,
        color: theme.palette.common.white,
    },
    [`&.${tableCellClasses.body}`]: {
        fontSize: 14,
    },
}));

const StyledTableRow = styled(TableRow)(({ theme }) => ({
    '&:nth-of-type(odd)': {
        backgroundColor: theme.palette.action.hover,
    },
    // hide last border
    '&:last-child td, &:last-child th': {
        border: 0,
    },
}));


const DisplayProducts = () => {
    const [ProductsList, setData] = useState([
        {
            id: 101,
            name: "Paracetamol",
            price: "$10",
            description: "To control fever",
            reqtemp: "25°C",
            manufacturing: "2023-01-15",
        },
        {
            id: 102,
            name: "Cetrizine",
            price: "$15",
            description: "For allergies",
            reqtemp: "30°C",
            manufacturing: "2023-02-20",
        },
        {
            id: 103,
            name: "Oxymeter",
            price: "$20",
            description: "For measuring oxygen level",
            reqtemp: "28°C",
            manufacturing: "2023-03-10",
        },
    ]);

    //const [ProductsList, setData] = useState();
    //const ContractAddress = "0xE4b876ed393E19FbD18eC99118647BcbFE5300F3" //"0xFa56954976bA7d616945c09A7e360499e7038d98";
    const ContractAddress = "0x262e4BBd3dCBb26d41e82F5ebb8B261A82B40151";
    
    async function requestAccount() {
        await window.ethereum.request({ method: "eth_requestAccounts" });
    }

    async function getProduct() {
        if (typeof window.ethereum !== "undefined") {
            requestAccount();
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            console.log(await signer.getAddress())

            const contract = new ethers.Contract(
                ContractAddress,
                SupplyChain.abi,
                provider
            );
            try {

                const Pdata = await contract.getProducts();
                //const Pdata = [{"description":"0x50617261636574616d6f6c"}];
                //{"Sr. No.":1}, "Product name":"Paracetamol","Product ID":0,"Description":"For fever","Price":10,"Required Temp.":30,"Manufacturing Date":"19-04-2022"}]
                console.log("data: ", Pdata);
                setData(Pdata);
                //console.log(contract);

            } catch (err) {
                console.log("Error: ", err);
            }
        }
    }

    if (ProductsList == null) {
        getProduct();
        return (
            <div style={{textAlign: "center", padding: "10%"}}>
            <Box sx={{ color: 'grey.500' }}>
                <CircularProgress color="inherit"/>
            </Box>
            </div>
        );
    }
    return (
        <TableContainer component={Paper} sx={{width: "80%", margin:"auto", marginTop: "5%"}}>
            <Table sx={{ minWidth: 650}} aria-label="simple table">
                <TableHead>
                    <StyledTableRow>
                        <StyledTableCell>Sr. No.</StyledTableCell>
                        <StyledTableCell align="left">Product&nbsp;Name</StyledTableCell>
                        <StyledTableCell>Product ID</StyledTableCell>
                        <StyledTableCell sx={{width: "40%"}}>Description</StyledTableCell>
                        <StyledTableCell>Price&nbsp;</StyledTableCell>
                        <StyledTableCell>Required&nbsp;Temp.</StyledTableCell>
                        <StyledTableCell align="right">Manufacturing&nbsp;Date</StyledTableCell>

                    </StyledTableRow>
                </TableHead>
                <TableBody>
                    {ProductsList.map((row, iterator) => (
                        <StyledTableRow
                            key={iterator}
                            sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
                        >
                            <StyledTableCell component="th" scope="row">{iterator + 1}</StyledTableCell>
                            <StyledTableCell align="left">{row.name}</StyledTableCell>
                            <StyledTableCell>{parseInt(row.id)}</StyledTableCell>
                            <StyledTableCell>{row.description}</StyledTableCell>
                            <StyledTableCell>{row.price}</StyledTableCell>
                            <StyledTableCell>{row.reqtemp}</StyledTableCell>
                            <StyledTableCell align="right">{row.manufacturing}</StyledTableCell>

                        </StyledTableRow>
                    ))}
                </TableBody>
            </Table>
        </TableContainer>
    );
}

export default DisplayProducts;