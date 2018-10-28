import { createStore, applyMiddleware } from "redux";
import { composeWithDevTools } from "redux-devtools-extension/developmentOnly";

import mainReducer from "./main.reducer";
import middleware from "./middleware"

export default initialState => createStore(
    mainReducer,
    initialState,
    composeWithDevTools(applyMiddleware(...middleware))
);