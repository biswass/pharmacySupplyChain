import React, { useState, useEffect } from 'react';
import SupplyChain from "../artifacts/contracts/SupplyChain.sol/Supplychain.json";
import { ethers } from "ethers";
import Paper from '@mui/material/Paper';
import CircularProgress from '@mui/material/CircularProgress';
import Box from '@mui/material/Box';
import InputBase from '@mui/material/InputBase';
// import Divider from '@mui/material/Divider';
import IconButton from '@mui/material/IconButton';
// import MenuIcon from '@mui/icons-material/Menu';
import SearchIcon from '@mui/icons-material/Search';
// import DirectionsIcon from '@mui/icons-material/Directions';
// import TextField from '@mui/material/TextField';
// import Button from '@mui/material/Button';
// import SendIcon from '@mui/icons-material/Send';
//import Events1 from './events.js';
import getInfo from './events.js';

import Timeline from '@mui/lab/Timeline';
import TimelineItem from '@mui/lab/TimelineItem';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineConnector from '@mui/lab/TimelineConnector';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineDot from '@mui/lab/TimelineDot';
import Typography from '@mui/material/Typography';
import TimelineOppositeContent from '@mui/lab/TimelineOppositeContent';

import StatusModal from './StatusModal.js';

const DisplayStatus = () => {
    const ContractAddress = "0xabDf73B90E87Fd0071C714567214e9c64F504B88" //"0xFa56954976bA7d616945c09A7e360499e7038d98";
    const searchResults = "";
    const { getInfo1 } = require('./events.js');
    const initialData = [
        /*{ role: 'Supplier', date: 'Nov 1 2023', timestamp: '0x61A80C0B' }/*,
        { role: 'Transporter', date: 'Nov 2 2023', timestamp: '0x61A80C0B' },
        { role: 'Manufacturer', date: 'Nov 3 2023', timestamp: '0x61A80C0B' },
        { role: 'Transporter', date: 'Nov 4 2023', timestamp: '0x61A80C0B'},
        { role: 'Wholesaler', date: 'Nov 5 2023', timestamp: '0x61A80C0B' },
        { role: 'Transporter', date: 'Nov 6 2023', timestamp: '0x61A80C0B' },
        { role: 'Distributor', date: 'Nov 7 2023', timestamp: '0x61A80C0B' },
        { role: 'Transporter', date: 'Nov 8 2023', timestamp: '0x61A80C0B' },
        { role: 'Pharma', date: '0x61A80C0B', timestamp: '0x61A80C0B' }*/
    ];
    //const [data, setData] = useState();
    const [id, setId] = useState(1);
    const [data,setData] = useState(initialData);

    async function requestAccount() {
        await window.ethereum.request({ method: "eth_requestAccounts" });
    }
    console.log(id);

    // Function to handle the status retrieval based on the entered product ID
    async function handleStatusRetrieval() {
        // Pass the entered product ID to the getStatus function
        await getStatus(id); // 'id' is the value from the input field
        console.log("searchResults: ", searchResults);
    }

    async function getStatus(itemAddress) {
        
        if (typeof window.ethereum !== "undefined") {
            requestAccount();
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            //console.log(await signer.getAddress())

            const contract = new ethers.Contract(
                ContractAddress,
                SupplyChain.abi,
                provider
            );

            try {

                //const Sdata = await contract.getUserInfo('0x262e4BBd3dCBb26d41e82F5ebb8B261A82B40151');
                //const Sdata = await DisplayEvent.we
                //console.log("data1: ", Sdata);
                //setData(Sdata);
                //console.log(contract);
                //const ADD = "0x24A3bA51771514351fdc67cE80d00cf45CD95751"
                const searchResults = await getInfo1(itemAddress);
                console.log("searchResults sender address: ", searchResults[0].returnValues[1]);
                console.log("searchResults timestamp: ", searchResults[0].returnValues[3]);
                /*setTimeout(() => {
                    console.log("searchResults1: ", searchResults);
                }, 3000);*/
                
                //console.log("addr: ", itemAddress);

                const updatedData = searchResults.map(result => ({
                    role: result.returnValues[1],
                    date: 'Nov 1 2023', // You might want to update this based on your logic
                    timestamp: result.returnValues[3]
                }));

  /*              const updatedData = [
                    { role: searchResults[0].returnValues[1], date: 'Nov 1 2023', timestamp: searchResults[0].returnValues[3] },
  
                ];*/
                setData(updatedData);
                //const [data, setData] = useState();
                //const [id, setId] = useState(1);
                //const [data,setData] = useState(updatedData);

            } catch (err) {
                console.log("Error: ", err);
            }
        }
    }

    /*function convertTimestamp(t) {
        var intTimestamp = parseInt(t, 16);
        // console.log(intTimestamp)
        var s = new Date(intTimestamp*1000);
        return String(s).substring(0, 24);
    }*/

    function convertTimestamp(timestamp) {
        const date = new Date(timestamp * 1000); // Convert seconds to milliseconds
        const options = { year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', timeZoneName: 'short' };
        return new Intl.DateTimeFormat('en-US', options).format(date);
    }

    return (
        <center>
        <div style={{padding: "2.5%"}}>
            <div>
                {/* <TextField variant="outlined" id="outlined" label="Enter Product ID" onChange={(e) => setId(e.target.value)} />
                <Button variant="contained" endIcon={<SendIcon />} onClick={getStatus} >
                Send
                </Button> */}
                <Paper
                sx={{ p: '2px 4px', display: 'flex', alignItems: 'center', width: 200 }}
                >
                <InputBase
                    sx={{ ml: 1, flex: 1 }}
                    placeholder="Enter Product ID"
                    onChange= {(e) => setId(e.target.value)}
                />
                <IconButton sx={{ p: '10px' }} aria-label="search" onClick={handleStatusRetrieval}>
                    <SearchIcon />
                </IconButton>
                </Paper>
            </div>
        </div>
        <div style={{color: "white"}}>
            {!data ? (
                <Box sx={{ color: 'grey.500' }}>
                    <CircularProgress color="inherit"/>
                </Box>
            ) : (
                <div>
                    <h1>Product Status</h1>

                <Timeline position="left">
                {data.map((row, iterator) => (
                    <TimelineItem key={iterator}>
                        <TimelineOppositeContent sx={{ py: '10px', px: 2}}>
                            {convertTimestamp(row.timestamp)}
                        </TimelineOppositeContent>
                        <TimelineSeparator>
                            <StatusModal statusData={row}/>
                            <TimelineConnector />
                        </TimelineSeparator>
                        <TimelineContent sx={{ py: '10px', px: 2 }}>
                        <Typography variant="h6" component="span">
                            {row[0]}
                        </Typography>
                        {parseInt(row[2], 10)<25? 
                            <Typography sx={{color: "lightgreen"}}>{row.temperature}</Typography> 
                        : 
                            <Typography sx={{color: "orange"}}>{row.role}</Typography>}
                        </TimelineContent>
                        
                    </TimelineItem> 
                ))}
                </Timeline>
                </div>
            )}
        </div>
        </center>
    );
}

export default DisplayStatus;