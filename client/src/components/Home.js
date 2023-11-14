import React, { useState, useEffect } from "react";
import "./Home.css";

const Home = () => {
  return (
    <div class="landing-wrapper">
      <div id="heading">Pharmacy Supply Chain</div>
      <div
        style={{
          width: "50%",
          margin: "auto",
          display: "flex",
          justifyContent: "center",
        }}
      >
        <ul style={{ marginTop: "2%" }}>
          <li>
            We have 8 pre-defined roles - Admin, Supplier, Manufacturer, Wholesaler, Distributer, Pharma, Transporter, Customer
          </li>
          <li style={{ marginTop: "2%" }}>
            A list of 3 pharmacy products exist in different phases of the supply chain
          </li>
          <li style={{ marginTop: "2%" }}>
            Using this portal you'll be able to track these different items with their history
          </li>
        </ul>
      </div>
      <p style={{ paddingTop: "3%" }}>
        Made By: The fantastic beasts
      </p>
    </div>
  );
};

export default Home;
