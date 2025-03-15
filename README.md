# Newsify

Overview

The News Aggregator App is a SwiftUI-based application that fetches and displays the latest news headlines using the NewsAPI. Users can browse news articles, save their favorite ones, and toggle between light and dark mode. The app also features a built-in WebView for reading full articles and an option to share news.

Features

Fetch News: Retrieves top headlines from NewsAPI to keep users updated.

Dark Mode Support: Provides a seamless UI experience by supporting both light and dark themes.

Save Articles: Users can bookmark articles for later reading.

WebView Support: Allows users to read full articles directly within the app using an embedded browser.

Share Functionality: Enables users to share news articles via iOS's built-in sharing options.

CoreData Integration: Saves and manages favorite articles locally for offline access.

Installation

Clone this repository:

git clone https://github.com/NikunjTyagi26/Newsify.git

Open the project in Xcode.

Ensure you have an active internet connection to fetch news.

Run the app on an iOS simulator or a physical device.

Technologies Used

SwiftUI

Used for building the user interface with a declarative syntax that ensures smooth animations and responsive layouts.

WebKit

Incorporates a WebView to allow users to read full articles from external websites without leaving the app.

CoreData

Utilized for persistent storage, allowing users to save and retrieve their favorite articles even when offline.

URLSession

Handles API calls efficiently to fetch real-time news data from NewsAPI.

Combine Framework

Used for handling asynchronous data streams, ensuring a responsive and smooth user experience.

API Integration

The app fetches news from NewsAPI using the following endpoint:

https://newsapi.org/v2/top-headlines?country=us&apiKey=YOUR_API_KEY

Replace YOUR_API_KEY with your valid API key from NewsAPI.

App Structure

1. ContentView.swift

Contains a TabView with two main tabs: HomeView and SavedView.

Manages dark mode settings using @AppStorage.

2. HomeView.swift

Fetches news using NewsViewModel.

Displays articles in a List.

Provides a dark mode toggle button for theme switching.

3. NewsViewModel.swift

Handles network requests and data parsing.

Uses Combine to fetch data asynchronously.

Parses JSON responses into Article models.

4. Article.swift

Defines the data model for news articles.

Implements Codable to facilitate JSON decoding.

5. NewsCard.swift

Displays each news article in a visually appealing card layout.

Includes an image, title, and description of the news.

Provides a "Read More" button for in-depth reading.

6. ArticleDetailView.swift

Embeds a WebView to display full articles.

Provides options to save articles and share via ShareSheet.

7. WebView.swift

Implements UIViewRepresentable to load web pages inside SwiftUI.

Ensures smooth navigation within external articles.

8. SavedView.swift

Displays a list of saved articles.

Allows users to delete saved articles with a swipe gesture.

9. SavedArticles.swift

Manages saved articles using CoreData.

Provides functions to save, fetch, and delete articles.

How to Use

Browse News: Open the app and view top headlines.

Read Articles: Tap on any article to open it in the WebView.

Save Articles: Bookmark articles for later reading.

Delete Articles: Manage saved articles in the "Saved" tab.

Toggle Dark Mode: Switch between light and dark mode using the sun/moon icon.

Future Improvements

Implement search functionality to filter news by keywords.

Introduce category-based news filtering (e.g., Sports, Technology, Politics).

Improve UI/UX with animations and enhanced styling.

Enable push notifications for breaking news alerts.

Integrate AI-based news recommendations.

Author

Nikunj TyagiGitHub | LinkedIn

License

This project is licensed under the MIT License. Feel free to contribute and improve!
