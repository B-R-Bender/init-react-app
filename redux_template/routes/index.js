import React from "react";
import {Switch, Router, Route} from "react-router";
import createBrowserHistory from "history/createBrowserHistory";

export const history = createBrowserHistory();

const AppRouter = () => (
    <Router history={history}>
        <Switch>
            <Route path={"/"} component={() => "App screen"}/>
        </Switch>
    </Router>
);

export default AppRouter;