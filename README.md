# User Authentication API

A simple Rails API-only application for user authentication and management built with Grape and documented with Swagger.

## Overview

This project provides a RESTful API for user registration, authentication, and management. It uses JWT (JSON Web Token) for authentication and Grape for API development with Swagger documentation.

## Features

- User registration
- User authentication (login with JWT)
- Get user details
- Update user information
- API documentation with Swagger

## Technology Stack

- Ruby on Rails
- Grape API framework
- grape-swagger for API documentation
- JWT for authentication

## API Endpoints

### Authentication

- `POST /api/auth/login` - Login and get a JWT token

### User Management

- `POST /api/user/register` - Register a new user
- `GET /api/user/:id` - Get user details
- `PUT /api/user/:id` - Update user information

## Setup

1. Clone the repository
```bash
git clone git@github.com:lemachegabriel/grape_auth_api.git
cd grape_auth_api
```

2. Install dependencies
```bash
bundle install
```

3. Setup the database
```bash
rails db:create db:migrate
```

4. Start the server
```bash
rails server
```

## API Documentation

The API documentation is available through Swagger:

- JSON format: `http://localhost:3000/api/swagger_doc`
- If you're not using API-only mode or have configured Swagger UI: `http://localhost:3000/swagger`

## Authentication

The API uses JWT for authentication:

1. Register a user or login to get a token
2. Include the token in the Authorization header for protected routes:
```
Authorization: Bearer [your-token]
```
