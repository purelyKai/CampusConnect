import * as functions from "firebase-functions";
import express from "express";
import { mapsProxyHandler } from "./controllers/mapsProxyController";

const app = express();

// Route for Google Maps Proxy
app.get("/maps/api/:service", mapsProxyHandler);

// Export the function
exports.api = functions.https.onRequest(app);
