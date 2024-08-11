# SocialWave iOS App

SocialWave is a fully functional iOS social media application developed using SwiftUI in Xcode, with a Node.js server as its backend, connected to a MongoDB database. This application allows users to create accounts, make posts, comment, like, and communicate with friends through chat. It also features OTP authentication, automatic login with JWT, friend suggestions, and real-time notifications.

## Table of Contents

- [Installation](#installation)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Folder Structure](#folder-structure)
- [Setup](#setup)
  - [Xcode](#xcode)
  - [Node.js Server](#nodejs-server)
  - [MongoDB Database](#mongodb-database)
- [Usage](#usage)
- [Backend](#backend)
- [MongoDB Collections](#mongodb-collections)
- [Screenshots From The Screens Of The App](#screenshots-from-the-screens-of-the-app)

## Installation

Clone the repository to your local machine:

\`\`\`bash
git clone https://github.com/yourusername/SocialWaveApp.git
\`\`\`

## Features

- User account creation and OTP email verification
- Password recovery and update with OTP
- Friend requests, accept or reject requests
- Create, like, and comment on posts
- Real-time notifications for likes, comments, and friend requests
- Direct messaging (chat) between friends
- Friend suggestion algorithm based on mutual friends
- Secure HTTPS communication

## Technologies Used

- **Xcode** for iOS app development
- **Node.js** for the backend server
- **MongoDB** for the database
- **Socket.IO** for real-time communication

## Folder Structure

The project is organized as follows:

### Backend

- `backend`: Contains server-related files.
  - `server.js`: Main server file.
  - `config`: Configuration files for the database connection.
  - `api`: API routes and controllers for database interactions.
    - `controllers`: Functions handling API requests.
    - `models`: MongoDB models for User, Post, Comment, etc.
    - `routes`: Defines API routes.
    - `services`: Functions for database queries.
    - `utils`: Utility functions for various backend tasks.
- `creationOfDatabase`: Python script for populating the database with random data.

### Frontend

- `SocialWave`: Contains the iOS app's frontend code.
  - `SocialWaveApp`: Main app folder.
    - `Views`: Contains SwiftUI views for different screens.
    - `Models`: Data models for the app.
    - `ViewModels`: Logic and state management for each screen.
    - `Networking`: Handles API calls to the backend server.
    - `Utilities`: Utility functions and constants.

## Setup

### Xcode

1. Open the `SocialWaveApp` project in Xcode.
2. Build and run the iOS application on a simulator or a physical device.

### Node.js Server

1. Navigate to the `backend` folder.
2. Install the required Node.js packages:

\`\`\`bash
npm install
\`\`\`

3. Start the server:

\`\`\`bash
npm start
\`\`\`

### MongoDB Database

1. Create a MongoDB Atlas account and set up a new cluster.
2. Obtain the connection string and update the `creationOfDatabase.py` script and `DatabaseConfig.js` file with your MongoDB credentials.
3. Populate the database by running:

\`\`\`bash
python creationOfDatabase.py
\`\`\`

## Usage

- Launch the SocialWave app on your iOS device or simulator.
- Explore features such as posting, commenting, liking, and chatting with friends.

## Backend

The backend for SocialWave is implemented using Node.js and MongoDB. The `backend` folder contains all server-side logic, including API routes, database models, and real-time communication setup.

To run the backend, follow the instructions in the [Setup](#setup) section.

## MongoDB Collections

### All DB Collections
<div>
  <img src="readmeImages/allDBCollections.png" width="400" height="600" />
</div>
![All DB Collections](readmeImages/allDBCollections.png)
![User Collection Details](readmeImages/UserCollection.png)
![Post Collection Details](readmeImages/PostCollection.png)
![OTP Collection Details](readmeImages/OTPCollection.png)
![Comment Collection Details](readmeImages/CommentCollection.png)
![Chat Collection Details](readmeImages/ChatCollection.png)
![Message Collection Details](readmeImages/MessageCollection.png)
![Notification Collection Details](readmeImages/NotificationCollection.png)

## Screenshots From The Screens Of The App

<div float="left">
  <img src="readmeImages/login.jpg" width="180" height="400" />
  <img src="readmeImages/signup.jpg" width="180" height="400" />
  <img src="readmeImages/otp1.jpg" width="180" height="400" />
  <img src="readmeImages/reset_pass.jpg" width="180" height="400" />
</div>

<div float="left">
  <img src="readmeImages/reset_pass2.jpg" width="180" height="400" />
  <img src="readmeImages/reset_pass4.jpg" width="180" height="400" />
  <img src="readmeImages/home.jpg" width="180" height="400" />
  <img src="readmeImages/home_suggest_friends.jpg" width="180" height="400" />
</div>

<div float="left">
  <img src="readmeImages/multiple_photos_post.jpg" width="180" height="400" />
  <img src="readmeImages/edit_post.jpg" width="180" height="400" />
  <img src="readmeImages/edit_profile.jpg" width="180" height="400" />
  <img src="readmeImages/search.jpg" width="180" height="400" />
</div>

<div float="left">
  <img src="readmeImages/requests.jpg" width="180" height="400" />
  <img src="readmeImages/profile_user.jpg" width="180" height="400" />
  <img src="readmeImages/profile_not_friend.jpg" width="180" height="400" />
  <img src="readmeImages/posts_list.jpg" width="180" height="400" />
</div>

<div float="left">
  <img src="readmeImages/likes.jpg" width="180" height="400" />
  <img src="readmeImages/mycomment.jpg" width="180" height="400" />
  <img src="readmeImages/chat.jpg" width="180" height="400" />
  <img src="readmeImages/inbox_chats.jpg" width="180" height="400" />
</div>

<div float="left">
  <img src="readmeImages/new_message.jpg" width="180" height="400" />
  <img src="readmeImages/notifications.jpg" width="180" height="400" />
</div>