import * as functions from "firebase-functions";

// Example: Hello World Function
export const helloWorld = functions.https.onRequest((request, response) => {
  console.log("HelloWorld function triggered");
  response.send("Hello from Firebase!");
});
