# Learning Dashboard

A small Learning Dashboard iOS application built using Swift, SwiftUI, and MVVM.

## 1. Architecture

### Why did you choose your architecture?

I used MVVM because it provides a simple separation between the UI and the application logic.

* **View:** Displays the UI using SwiftUI.
* **ViewModel:** Handles UI state, user actions, and business logic.
* **Repository:** Acts as a single place for getting course data.
* **Network Service:** Handles API/network requests.
* **Storage Service:** Handles local data for offline usage.

This structure keeps the code organized and makes it easier to test and maintain.

## 2. Offline Support

### How are you storing and loading offline data?

I used Core Data to store the course and lesson data locally.

When the dashboard loads, the app first tries to get the latest course data from the network and saves it locally.

If the network request fails, the repository loads the previously saved courses from Core Data instead.

Lesson completion is also saved locally, so the user's progress is available when the app is used offline.

## 3. Security

### Where would you store authentication tokens in a production application?

In a production application, I would store authentication tokens securely in the **iOS Keychain**.

I would not store sensitive authentication tokens in `UserDefaults`.

## 4. Scale

### If this application had 1 million users + hundreds of courses, mention 3–5 things you would improve.

1. **Pagination:** Load courses in smaller pages instead of loading hundreds of courses at once.

2. **Better API and caching:** Improve API response times and use proper caching to reduce unnecessary network requests.

3. **Background Sync:** Sync lesson progress with the server when the device gets an internet connection.

4. **Monitoring:** Use Crashlytics and analytics to monitor crashes, performance, and important user flows.

5. **Image/CDN support:** If courses contain images or videos, use a CDN and proper image/media caching.

## 5. Second Platform

### Explain briefly how you would implement it on Android.

I would build the same application using **Kotlin and Jetpack Compose**.

I would follow a similar MVVM structure:

* **UI:** Jetpack Compose
* **State Management:** ViewModel with StateFlow
* **Network:** Retrofit with OkHttp
* **Offline Storage:** Room Database
* **Async Operations:** Kotlin Coroutines

The overall architecture would remain similar, while using the platform-specific Android technologies.
