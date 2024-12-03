# CampusConnect

**CampusConnect** is a cross-platform application designed to help students connect and collaborate on campus. With CampusConnect, students can easily find and join activities, organize events, and interact with peers based on common interests. The app features an interactive map where users can pin activities, view event details, and receive notifications about upcoming events.

## Key Features

- **Interactive Map:** Visualize and interact with activities pinned on a dynamic map.
- **Event Posting and Joining:** Post new events or join existing ones based on your interests.
- **Location-Based Notifications:** Receive alerts about activities near your location.
- **Real-Time Updates:** Stay updated with real-time data on events and user interactions.

## Technology Stack

- **Frontend:**

  - **Flutter:** Used for building a responsive and cross-platform application compatible with iOS, Android, and Web.

- **Mapping and Location Services:**

  - **Mapbox Flutter Plugin:** Provides interactive map features and custom pin placements.
  - **Geolocator Plugin:** Allows the app to obtain and use user location data.
  - **Geofencing Plugin:** Enables location-based notifications and features.

- **Backend and Database:**

  - **Firebase:**
    - **Firebase Authentication:** Manages user authentication and sign-in.
    - **Firebase Firestore:** Stores and synchronizes data in real time.
    - **Firebase Cloud Functions:** Executes serverless backend logic.
    - **Firebase Cloud Storage:** Handles file storage for user-uploaded content.
    - **Firebase Cloud Messaging (FCM):** Sends notifications to users.

- **Analytics:**

  - **Google Analytics for Firebase:** Tracks user engagement and app performance.

- **CI/CD:**
  - **GitHub Actions:** Automates the build, test, and deployment workflows.

## Developer Notes

- **Backend:**
  - **Deploy Cloud Functions:** Updates backend logic implemented in "backend/functions/src/".
    ```bash
    cd backend
    firebase deploy --only functions
    ```
- **Frontend:**

  Update and set up flutter.

  ```bash
  cd frontend/app
  flutter pub get
  ```

  Run the app:

  - Web:
    ```bash
    flutter run
    ```
  - Mobile (Android):
    ```bash
    flutter emulator --launch Medium_Phone_API_35
    flutter run
    ```
    For mobile, ensure Android Studio is properly configured. Replace `Medium_Phone_API_35` with your device.
