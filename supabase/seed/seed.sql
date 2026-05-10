--- Sample template of how to initialize:

BEGIN;

INSERT INTO database.users (
    user_id,
    password_hash,
    email,
    date_created,
    name
)
VALUES (
    1,
    12345,
    test,
    test@test.com,
    '2026-04-12',
)