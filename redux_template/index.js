import React from "react";
import ReactDOM from "react-dom";
import {Provider} from "react-redux";

import "./index.css";

import configureStore from "./store";
import Routes from "./routes";

const Application = () => (
    <Provider store={configureStore()}>
        <Routes/>
    </Provider>
);

ReactDOM.render(<Application/>, document.getElementById("root"));