# Newsify App



## Overview
The **News Aggregator App** is a SwiftUI-based iOS application designed to fetch and display the latest news headlines using the [NewsAPI](https://newsapi.org/). Users can browse news articles, save their favorite ones, and toggle between light and dark themes. The app also features an embedded WebView for reading full articles and a share functionality to share news with others.

---

## Features
- **Fetch News**: Retrieves top headlines from NewsAPI to keep users updated with the latest news.
- **Dark Mode Support**: Provides a seamless user experience with light and dark theme options.
- **Save Articles**: Allows users to bookmark articles for offline reading.
- **WebView Support**: Enables users to read full articles directly within the app using an embedded browser.
- **Share Functionality**: Lets users share news articles via iOS's built-in sharing options.
- **Core Data Integration**: Saves and manages favorite articles locally for offline access.

---

## Installation
Follow these steps to set up and run the project:

### Prerequisites
- Xcode 14 or later.
- iOS 16 or later.
- A valid API key from [NewsAPI](https://newsapi.org/).

### Steps
1. **Clone the repository**:
   ```bash
   git clone https://github.com/NikunjTyagi26/Newsify.git

   ## Installation

### Open the project in Xcode:
1. Navigate to the project directory and open `NewsApp.xcodeproj` in Xcode.

### Add your API Key:
1. Open `NewsViewModel.swift`.
2. Replace `YOUR_API_KEY` with your valid API key from [NewsAPI](https://newsapi.org/).

### Run the app:
1. Build and run the app on an iOS simulator or a physical device.

---

## Technologies Used

- **SwiftUI**: For building a declarative and responsive user interface.
- **WebKit**: For embedding a WebView to display full articles within the app.
- **Core Data**: For persistent storage of saved articles.
- **URLSession**: For efficient network requests to fetch news data.
- **Combine Framework**: For handling asynchronous data streams and ensuring a smooth user experience.

---

## API Integration

The app fetches news from the [NewsAPI](https://newsapi.org/) using the following endpoint:

Replace `YOUR_API_KEY` with your valid API key from NewsAPI.

---

## App Structure

The app is structured into the following components:

### 1. **ContentView.swift**
   - Contains a `TabView` with two main tabs: `HomeView` and `SavedView`.
   - Manages dark mode settings using `@AppStorage`.

### 2. **HomeView.swift**
   - Fetches news using `NewsViewModel`.
   - Displays articles in a `List`.
   - Provides a dark mode toggle button for theme switching.

### 3. **NewsViewModel.swift**
   - Handles network requests and data parsing.
   - Uses Combine to fetch data asynchronously.
   - Parses JSON responses into `Article` models.

### 4. **Article.swift**
   - Defines the data model for news articles.
   - Implements `Codable` to facilitate JSON decoding.

### 5. **NewsCard.swift**
   - Displays each news article in a visually appealing card layout.
   - Includes an image, title, and description of the news.
   - Provides a "Read More" button for in-depth reading.

### 6. **ArticleDetailView.swift**
   - Embeds a `WebView` to display full articles.
   - Provides options to save articles and share via `ShareSheet`.

### 7. **WebView.swift**
   - Implements `UIViewRepresentable` to load web pages inside SwiftUI.
   - Ensures smooth navigation within external articles.

### 8. **SavedView.swift**
   - Displays a list of saved articles.
   - Allows users to delete saved articles with a swipe gesture.

### 9. **SavedArticles.swift**
   - Manages saved articles using Core Data.
   - Provides functions to save, fetch, and delete articles.

---

## How to Use

1. **Browse News**:
   - Open the app to view top headlines on the Home tab.

2. **Read Articles**:
   - Tap on any article to open it in the WebView for full reading.

3. **Save Articles**:
   - Bookmark articles by tapping the save icon in the Article Detail View.

4. **Delete Articles**:
   - Manage saved articles in the "Saved" tab by swiping to delete.

5. **Toggle Dark Mode**:
   - Switch between light and dark mode using the sun/moon icon in the navigation bar.
