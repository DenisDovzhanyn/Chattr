# Chattr API

The Chattr API is the core backend service responsible for managing user accounts, chats, messages, and encryption keys.
This service handles user authentication and provides endpoints for interacting with chats and messages.

## Features

- **User Authentication**: Users can log in and sign up.
- **JWT Tokens**: Upon login, users receive a JWT token with their `user_id` as a claim for access control.
- **Chat Management**: Users can create chats, retrieve their chat list, and access old messages stored in the database.
- **Offline Message Retrieval**: Users can retrieve messages sent while they were offline.
- **Encryption Key Management**: 
  - Retrieve chat encryption keys from the Redis cache.
  - Send chat encryption keys to the Redis cache.

## Tech Stack

- **PostgreSQL**: Primary database for user accounts, chats, and messages.
- **Redis**: cache for managing encryption keys with a short TTL.
- **JWT**: Token-based authentication for secure user access.

## Endpoints

### Authentication
- `POST /signup`: Sign up a new user.
- `POST /login`: Log in and receive a JWT token.
- `POST /login/key`: Log in with one time key , change password and receive JWT token.

### Chat Management
- `GET /chats`: Get the list of chats for the authenticated user.
- `POST /chats`: Create a new chat.
- `POST /chats/add_user`: Adds a user to the chat.
- `DELETE /chats/remove_user`: Removes the logged in user from a chat.

### Message Management
- `GET /chats/messages`: Retrieve old messages for a specific chat.

### Encryption Key Management
- `GET /keys/:chat_id`: Retrieve encryption keys for a specific chat.
- `POST /keys/:chat_id`: Send encryption keys for a specific chat.

