# SnapShop User App

Welcome to the SnapShop User App, part of the SnapShop m-commerce platform. This app is designed to provide customers with a seamless and intuitive shopping experience on iOS devices.

## Project Overview

The SnapShop User App allows users to:

- Browse products by categories and brands.
- Search for specific products or brands.
- Add products to a wishlist.
- Manage a shopping cart and proceed to checkout.
- View order history and details.
- Make payments via cash or credit card.
- Authentication
- View App in dark mode.
- Pay using Apple Pay.

## Architectural Design Pattern

The SnapShop User App follows the **MVVM (Model-View-ViewModel)** architectural pattern:

- **Model**: Represents data and business logic.
- **View**: Displays the UI and interacts with users.
- **ViewModel**: Mediates between the View and the Model, handling logic and state management.

## Technologies Used

- **SwiftUI**: Declarative UI framework for building modern interfaces.
- **URLSession**: Swift-based HTTP networking library for API interactions.
- **Swift**: Primary programming language for iOS app development.
- **Reachability**: Library for monitoring network connectivity.
- **Lottie-iOS**: Animation library for creating engaging UI animations.
- **MVVM**: Design pattern for separating UI from business logic.
- **XCTest**: Framework for unit testing to ensure code reliability.

## Getting Started

### Prerequisites

- **Xcode**: Install the latest version of Xcode from the App Store.
- **Swift Package Manager (SPM)**: For managing Swift dependencies.
- **CocoaPods**: Dependency manager for iOS projects.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/AbdullahM98/SnapShop-User.git
   cd SnapShop-User
   ```

2. Install dependencies:

   ```bash
   pod install
   ```

3. Open the workspace in Xcode:

   ```bash
   open SnapShopUser.xcworkspace
   ```

4. Build and run the User App target on your preferred device or simulator.

### Configuration

1. Configure API credentials and endpoints in the `Const.swift` file for the User app.

2. Ensure network connectivity for seamless interaction with the backend APIs.

## Usage

- **Browse Products**: Explore products by categories and brands.
- **Search**: Find specific products or brands quickly.
- **Wishlist**: Save favorite products for future reference.
- **Shopping Cart**: Add products, manage quantities, and proceed to checkout.
- **Order History**: View past orders and their details.


Thank you for using SnapShop User App! We hope you enjoy a seamless shopping experience.

