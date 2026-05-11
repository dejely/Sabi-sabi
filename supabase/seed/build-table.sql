BEGIN;

CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE IF NOT EXISTS board (
    board_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    visibility TEXT NOT NULL CHECK (visibility IN ('public', 'private')),
    status TEXT NOT NULL CHECK (status IN ('pending', 'opened', 'closed', 'removed')),
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES user(user_id)

);

CREATE TABLE IF NOT EXISTS tag (
    tag_id INTEGER PRIMARY KEY,
    tag_name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS board_tag (

    board_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,

    PRIMARY KEY (board_id, tag_id), -- Composite PK

    FOREIGN KEY (tag_id) REFERENCES tag(tag_id),
    FOREIGN KEY (board_id) REFERENCES board(board_id)
);

CREATE TABLE IF NOT EXISTS access (

    role TEXT CHECK (role IN('superadmin', 'admin', 'user', 'moderator')),

    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (board_id) REFERENCES board(board_id) ON DELETE CASCADE
); 

CREATE TABLE IF NOT EXISTS note (
    note_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    board_id INTEGER,
    note_name TEXT NOT NULL,
    note_content TEXT NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visibility TEXT NOT NULL CHECK (visibility IN('public', 'pricvate')),
    status TEXT NOT NULL CHECK (status IN ('pending', 'opened', 'closed', 'removed')),

    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (board_id) REFERENCES board(board_id) ON DELETE CASCADE



);

CREATE TABLE IF NOT EXISTS messages(
    message_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    board_id INTEGER,
    note_id INTEGER,
    parent_message_id INTEGER,
    anonymous BOOLEAN NOT NULL DEFAULT FALSE,
    anonymous_nickname TEXT,
    content TEXT NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL CHECK (status IN ('pending', 'opened', 'closed', 'removed')),
    
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (board_id) REFERENCES board(board_id) ON DELETE CASCADE,
    FOREIGN KEY (note_id) REFERENCES note(note_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_message_id) REFERENCES messages(message_id) ON DELETE SET NULL,

    CHECK ( -- initial guard
        board_id IS NOT NULL OR note_id IS NOT NULL
    )
);

COMMIT;

