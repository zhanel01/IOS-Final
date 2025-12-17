# IOS-Final
# JEANELLE – Online Cosmetics Marketplace (iOS App)

## 📱 Project Overview

**JEANELLE** is a modern iOS application developed as a **final project for the iOS Development course**.  
The app represents an **online cosmetics marketplace**, allowing users to browse products, manage favorites, add items to a cart, and control their personal profile.

The main goal of this project is to demonstrate practical skills in:
- iOS UI development using Storyboards
- Auto Layout and adaptive design
- Navigation and modular app structure
- Networking and data handling
- Local data storage
- Clean and maintainable Swift code

---

## ✨ Features

### Core Modules (Tab Bar)
- **Home**
  - Product list displayed using `UITableView`
  - Custom table view cells
  - Product images, titles, and prices
- **Favorites**
  - Save and view favorite products
  - Persistent storage using `UserDefaults`
- **Cart**
  - Add/remove products
  - Quantity management
- **Profile**
  - User information input using text fields and switches
  - Preferences stored locally

### Optional / Experimental Feature
- **Smart Checkup (Planned Feature)**
  - Personalized cosmetic recommendations (concept feature)
  - Implementation depends on available time before exams

---

## 🛠 Technical Requirements Implemented

### UI Components
- `UILabel`
- `UIImageView`
- `UIButton`
- `UITextField`
- `UITextView`
- `UISwitch`
- `UISegmentedControl`
- `UISlider`
- `UIActivityIndicatorView`

### Layout & Design
- Storyboards for all screens
- Auto Layout with **no constraint warnings**
- Stack Views used where appropriate
- Adaptive UI for different screen sizes

### Navigation
- `UITabBarController` for main app sections
- `UINavigationController` for hierarchical navigation
- Clean and intuitive flow between screens

### Table View
- `UITableView` with custom cells
- Dynamic data loading
- Cell reuse for performance optimization

### Networking
- Network requests using `URLSession`
- JSON parsing and model mapping
- Error handling with user-friendly alerts
- Loading indicators during API calls

### Local Data Storage
- `UserDefaults` for:
  - Favorites
  - User preferences
  - Cart data

---

## 🧪 Testing
- Unit tests implemented using `XCTest`
- Core logic and data handling tested

---

## 📦 Dependencies
- No mandatory external libraries
- Swift Package Manager can be used if needed in future versions

---

## ▶️ How to Run the Project

1. Clone the repository
2. Open the project in Xcode
3. Select an iOS Simulator
4. Press Run (▶︎)

   
## 🎥 Demo

A demo video of the application is provided as part of the project submission.
## 👩‍💻 Authors

This application was developed as a group project for the iOS Development course.

Team:
- dikony1
- zhanel01
