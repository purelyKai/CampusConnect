import { Request, Response } from "express";
import * as admin from "firebase-admin";

// Initialize Firebase Admin SDK
admin.initializeApp();

// Initialize Firestore
const db = admin.firestore();

// Pin model interface
interface Pin {
  userEmail: string;
  title: string;
  description: string;
  timestamp: admin.firestore.FieldValue;
  location: {
    lat: number;
    lng: number;
  };
}

// Add Pin function
export const addPin = async (req: Request, res: Response): Promise<void> => {
  const { userEmail, title, description, lat, lng } = req.body;

  // Prepare pin data
  const newPin: Pin = {
    userEmail,
    title,
    description,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    location: { lat, lng },
  };

  try {
    const pinRef = await db.collection("pins").add(newPin);
    res.status(201).json({ id: pinRef.id, message: "Pin added successfully" });
  } catch (error) {
    console.error("Error adding pin: ", error);
    res.status(500).json({ error: "Failed to add pin" });
  }
};

// Get Pins function
export const getPins = async (req: Request, res: Response): Promise<void> => {
  try {
    const snapshot = await db.collection("pins").get();
    const pins = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));
    res.status(200).json(pins);
  } catch (error) {
    console.error("Error fetching pins: ", error);
    res.status(500).json({ error: "Failed to fetch pins" });
  }
};

// Delete Pin function
export const deletePin = async (req: Request, res: Response): Promise<void> => {
  const { pinId, userEmail } = req.body;

  try {
    const pinRef = db.collection("pins").doc(pinId);
    const pinDoc = await pinRef.get();

    if (!pinDoc.exists) {
      res.status(404).json({ error: "Pin not found" });
      return;
    }

    const pinData = pinDoc.data();
    if (pinData?.userEmail !== userEmail) {
      res.status(403).json({ error: "You cannot delete another user's pin" });
      return;
    }

    await pinRef.delete();
    res.status(200).json({ message: "Pin deleted successfully" });
  } catch (error) {
    console.error("Error deleting pin: ", error);
    res.status(500).json({ error: "Failed to delete pin" });
  }
};

// Edit Pin function
export const editPin = async (req: Request, res: Response): Promise<void> => {
  const { pinId, title, description, lat, lng, userEmail } = req.body;

  try {
    const pinRef = db.collection("pins").doc(pinId);
    const pinDoc = await pinRef.get();

    if (!pinDoc.exists) {
      res.status(404).json({ error: "Pin not found" });
      return;
    }

    const pinData = pinDoc.data();
    if (pinData?.userEmail !== userEmail) {
      res.status(403).json({ error: "You cannot edit another user's pin" });
      return;
    }

    await pinRef.update({
      title,
      description,
      location: new admin.firestore.GeoPoint(lat, lng),
    });

    res.status(200).json({ message: "Pin updated successfully" });
  } catch (error) {
    console.error("Error editing pin: ", error);
    res.status(500).json({ error: "Failed to edit pin" });
  }
};
