-- Mini Social Media Application Schema
-- PostgreSQL / snake_case conventions

-- Drop tables for easy re-creation (development only)
DROP TABLE IF EXISTS likes CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS posts CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS metadata CASCADE;

-- 1. Users table (authentication fields)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(32) UNIQUE NOT NULL,
    email VARCHAR(128) UNIQUE NOT NULL,
    password_hash VARCHAR(256) NOT NULL, -- hashed password
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE
);

-- 2. Profiles table (linked to users)
CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    display_name VARCHAR(64) NOT NULL,
    bio TEXT,
    profile_picture_url VARCHAR(255),
    location VARCHAR(64),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Posts table (author reference)
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    author_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Comments table (user and post reference)
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. Likes table (user, post, uniqueness constraint)
CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- prevent double-liking
    UNIQUE (user_id, post_id)
);

-- 6. Metadata table (key-value storage)
CREATE TABLE metadata (
    id SERIAL PRIMARY KEY,
    key VARCHAR(64) UNIQUE NOT NULL,
    value TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Example relationships:
-- - users (1) <-> (1) profiles
-- - users (1) <-> (M) posts
-- - users (1) <-> (M) comments
-- - users (1) <-> (M) likes
-- - posts (1) <-> (M) comments
-- - posts (1) <-> (M) likes

-- Indexes for activity/feeds (optional advanced)
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX idx_likes_created_at ON likes(created_at DESC);
CREATE INDEX idx_comments_created_at ON comments(created_at DESC);

-- Sample Data (can be removed in production)
-- Users
INSERT INTO users (username, email, password_hash)
VALUES
('alice', 'alice@email.com', 'hashed_pw1'),
('bob', 'bob@email.com', 'hashed_pw2'),
('charlie', 'charlie@email.com', 'hashed_pw3');

-- Profiles
INSERT INTO profiles (user_id, display_name, bio, profile_picture_url, location)
VALUES
(1, 'Alice', 'Loves coffee and code.', NULL, 'New York'),
(2, 'Bob', 'Social butterfly.', NULL, 'San Francisco'),
(3, 'Charlie', 'Quiet observer.', NULL, 'Austin');

-- Posts
INSERT INTO posts (author_id, content)
VALUES
(1, 'Hello, world!'),
(2, 'Enjoying the sunny day!'),
(3, 'Looking for book recommendations.');

-- Comments
INSERT INTO comments (post_id, user_id, content)
VALUES
(1, 2, 'Welcome, Alice!'),
(2, 1, 'Glad you\'re having fun, Bob!'),
(3, 2, 'Try reading "Clean Code"!');

-- Likes
INSERT INTO likes (user_id, post_id)
VALUES
(1, 2),
(2, 1),
(3, 1);

-- Metadata
INSERT INTO metadata (key, value)
VALUES
('site_title', 'Mini Social Media App'),
('max_post_length', '1000');

-- Done: all major schema features for auth, posts, profiles, comments, likes, metadata, and timestamps/activity.

-- End of schema.sql
