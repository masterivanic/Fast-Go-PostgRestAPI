# Fast & GO PostgRest API

This project demonstrates how to set up a RESTful API using **PostgREST** with a PostgreSQL database. The API allows you to manage `Users` and `Subjects` stored in the database.

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Database Schema](#database-schema)
- [API Endpoints](#api-endpoints)
- [Running the Project](#running-the-project)
- [Testing the API](#testing-the-api)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Overview

This project uses:
- **PostgreSQL** as the database.
- **PostgREST** to automatically generate REST APIs from the database schema.
- **Docker** to containerize the database and API.

The database schema includes two tables:
- `api.User`: Stores user information.
- `api.Subject`: Stores subjects associated with users.

---

## Prerequisites

Before running the project, ensure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [curl](https://curl.se/) (for testing the API)

---

## Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/masterivanic/Fast-Go-PostgRestAPI.git
   cd postgrest-demo
   ```

2. **Start the Services**:
   Run the following command to start the PostgreSQL database and initialize the schema:
   ```bash
   docker-compose up -d
   ```

3. **Verify the Database**:
   Ensure the database is running and initialized by checking the logs:
   ```bash
   docker logs pgrest-db-container
   ```

4. **Check DB logs**:
   Verify db logging config work as weel
    ```bash
   docker logs pgrest-db-container 
   ```

---

## Database Schema

The database schema is defined in the `initdb/db.sql` file. It includes the following tables:

### `api.User`
- `user_id`: UUID (Primary Key)
- `name`: Text (Not Null)
- `address`: Text (Not Null)
- `created_at`: Timestamp with Time Zone (Default: Current Time)
- `updated_at`: Timestamp with Time Zone (Default: Current Time)

### `api.Subject`
- `subject_id`: UUID (Primary Key)
- `label`: Text (Not Null)
- `description`: Text
- `average`: Float (Must be >= 0)
- `created_at`: Timestamp with Time Zone (Default: Current Time)
- `user_id`: UUID (Foreign Key referencing `api.User`)

---

## API Endpoints

PostgREST automatically generates RESTful endpoints based on the database schema. Below are the available endpoints:

### Users
- **GET** `/user`: Fetch all users.
- **GET** `/user?select=name,address`: Fetch specific fields.
- **POST** `/user`: Create a new user.
- **PATCH** `/user?user_id=eq.{id}`: Update a user.
- **DELETE** `/user?user_id=eq.{id}`: Delete a user.

### Subjects
- **GET** `/subject`: Fetch all subjects.
- **GET** `/subject?select=label,description`: Fetch specific fields.
- **POST** `/subject`: Create a new subject.
- **PATCH** `/subject?subject_id=eq.{id}`: Update a subject.
- **DELETE** `/subject?subject_id=eq.{id}`: Delete a subject.

---

## Running the Project

0. **Create env file**:
   ```bash
   cp .env-example .env
   ```

1. **Start the Services**:
   ```bash
   docker-compose up -d
   ```

2. **Access the API**:
   The API will be available at `http://localhost:3000`.

3. **Test the API**:
   Use `curl` or a tool like [Postman](https://www.postman.com/) to interact with the API.

   Example:
   ```bash
   curl -i -X GET http://localhost:3000/user | jq '.'
   ```

---

## Testing the API

### Example Requests

1. **Fetch All Users**:
   ```bash
   curl -i -X GET http://localhost:3000/user | jq '.'
   ```

2. **Create a New User**:
   ```bash
   curl -i -X POST http://localhost:3000/user \
       -H "Authorization: Bearer token_generate_on_jwt_io_using_your_jwt_secret" \
       -H "Content-Type: application/json" \
       -d '{"name": "John Doe", "address": "123 Main St"}'
   ```

3. **Fetch All Subjects**:
   ```bash
   curl -i -X GET http://localhost:3000/subject | jq '.'
   ```

4. **Create a New Subject**:
   ```bash
   curl -i -X POST http://localhost:3000/subject \
       -H "Authorization: Bearer token_generate_on_jwt_io_using_your_jwt_secret" \
       -H "Content-Type: application/json" \
       -d '{"label": "Mathematics", "description": "Study of numbers", "average": 85.5, "user_id": "123e4567-e89b-12d3-a456-426614174000"}'
   ```

5. **Check postgRest server config is same as you define**
   ```bash
   curl "http://localhost:3001/config" | jq '.'
   ```

6. **Print runtime schema cache**
   ```bash
   curl "http://localhost:3001/schema_cache"
   ```
---

## Troubleshooting

### Common Issues

1. **Database Not Initialized**:
   - Ensure the `initdb/db.sql` script is correctly mounted and executed.
   - Check the logs for errors:
     ```bash
     docker logs pgrest-db-container
     ```

2. **API Not Responding**:
   - Ensure the PostgREST service is running.
   - Check the logs:
     ```bash
     docker logs postgrest-container
     ```

3. **Invalid JSON Response**:
   - Ensure the API is returning valid JSON. Use `curl -i` to inspect the raw response.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [PostgREST](https://postgrest.org/) for providing the REST API layer.
- [PostgreSQL](https://www.postgresql.org/) for the powerful database backend.
- [Docker](https://www.docker.com/) for containerization.

---

Feel free to contribute or report issues! 🚀


