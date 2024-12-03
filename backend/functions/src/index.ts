import * as functions from "firebase-functions";
import express from "express";
import { mapsProxyHandler } from "./controllers/mapsProxyController";
import {
  addPin,
  getPins,
  deletePin,
  editPin,
} from "./controllers/pinsController";

// Initialize the Express app
const app = express();

// Middleware for parsing JSON
app.use(express.json());

// Route for Google Maps Proxy (for services like geocoding, directions, etc.)
app.get("/maps/api/:service", mapsProxyHandler);

// Routes for managing pins
app.post("/pins", addPin); // Create a new pin
app.get("/pins", getPins); // Get all pins
app.put("/pins/edit", editPin); // Edit a pin (PUT route for updates)
app.delete("/pins/:pinId", deletePin); // Delete a specific pin (using :pinId as a parameter)

// Export the function
exports.api = functions.https.onRequest(app);
