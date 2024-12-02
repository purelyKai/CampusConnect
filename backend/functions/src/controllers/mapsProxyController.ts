import { Request, Response } from "express";
import axios from "axios";

// Proxy function to handle Google Maps API requests
export const mapsProxyHandler = async (
  req: Request,
  res: Response
): Promise<void> => {
  const GOOGLE_MAPS_API_KEY = process.env.GOOGLEMAPS_APIKEY;
  const { service } = req.params; // Extract the API service (e.g., "geocode")
  const queryParams = req.query; // Extract query parameters from the frontend

  try {
    // Forward request to Google Maps API
    const response = await axios.get(
      `https://maps.googleapis.com/maps/api/${service}/json`,
      {
        params: {
          ...queryParams,
          key: GOOGLE_MAPS_API_KEY,
        },
      }
    );

    res.status(200).json(response.data); // Send the response back to the frontend
  } catch (error) {
    console.error("Google Maps API Proxy Error:", error);
    res.status(500).send("Error with Google Maps API Proxy");
  }
};
