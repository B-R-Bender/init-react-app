import React from "react";
import ReactDOM from "react-dom";

import "./index.css";

import Routes from "./routes";

const Application = () => (
    <Routes/>
);

ReactDOM.render(<Application/>, document.getElementById("root"));