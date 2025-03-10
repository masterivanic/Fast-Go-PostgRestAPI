
--------------------------------------   SQL DB INITIALIZATION ------------------------------------
CREATE SCHEMA api;

-- Enable the uuid-ossp extension if not already enabled #(https://www.postgresql.org/docs/13/uuid-ossp.html)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS api.User (
    user_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS api.Subject (
    subject_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    label TEXT NOT NULL,
    description TEXT,
    average FLOAT CHECK (average >= 0),
    created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    user_id UUID REFERENCES api.User(user_id) ON DELETE CASCADE
);


CREATE ROLE api_user nologin;
CREATE ROLE api_anon nologin;

CREATE ROLE authenticator WITH NOINHERIT LOGIN PASSWORD '8Fny3FaXEFkh9ePA3';

GRANT api_user TO authenticator;
GRANT api_anon TO authenticator;

GRANT USAGE on SCHEMA api to api_anon;
GRANT SELECT on api.User to api_anon;
GRANT SELECT on api.Subject to api_anon;

GRANT ALL on schema api to api_user;
GRANT ALL on api.User to api_user;
GRANT ALL on api.Subject to api_user;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA api TO api_user;

CREATE OR REPLACE FUNCTION api.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Grant execute permission on the function to api_user
GRANT EXECUTE ON FUNCTION api.update_updated_at_column() TO api_user;

CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON api.User
FOR EACH ROW
EXECUTE FUNCTION api.update_updated_at_column();

ALTER DEFAULT PRIVILEGES IN SCHEMA api GRANT EXECUTE ON FUNCTIONS TO api_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA api GRANT TRIGGER ON TABLES TO api_user;


-- Insert  data in db with random data
INSERT INTO api.User (name, address)
VALUES
    ('John Doe', '123 Main St'),
    ('Jane Smith', '456 Elm St'),
    ('Alice Johnson', '789 Oak St'),
    ('Bob Brown', '321 Pine St'),
    ('Charlie Davis', '654 Maple St');

INSERT INTO api.Subject (label, description, average, user_id)
VALUES
    ('Mathematics', 'Study of numbers and formulas', 85.5, (SELECT user_id FROM api.User WHERE name = 'John Doe' LIMIT 1)),
    ('History', 'Study of past events', 70.0, (SELECT user_id FROM api.User WHERE name = 'John Doe' LIMIT 1)),
    ('Science', 'Study of the natural world', 90.0, (SELECT user_id FROM api.User WHERE name = 'Jane Smith' LIMIT 1)),
    ('Literature', 'Study of written works', 80.0, (SELECT user_id FROM api.User WHERE name = 'Alice Johnson' LIMIT 1)),
    ('Art', 'Study of creative expression', 95.0, (SELECT user_id FROM api.User WHERE name = 'Bob Brown' LIMIT 1));