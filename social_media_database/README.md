# Social Media Database (PostgreSQL)

This folder contains the PostgreSQL schema setup and sample data for the mini social media application.

## Schema Setup

To create the database tables and insert initial data:

1. Connect to the PostgreSQL instance (see setup and credentials in `startup.sh`, `db_connection.txt`, or the `db_visualizer/postgres.env`):

```sh
psql -U <user> -d <database> -p <port> -h <host>
```

2. Run the schema:

```sh
\i schema.sql
```

## Tables

- `users`: Authentication, username, email, password hash, etc.
- `profiles`: Profile info linked to users.
- `posts`: User posts (author, content, timestamps).
- `comments`: Comments on posts (user, post references).
- `likes`: Likes for posts (unique per user-post).
- `metadata`: Key-value table for app settings/info.

## Development Notes

- Foreign keys ensure referential integrity.
- Timestamps recorded for feeds/activity support.
- Sample users, profiles, posts, comments, and likes for testing.
- Snake_case style throughout.

**For production, remove or modify sample data as needed!**
