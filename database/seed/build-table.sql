SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS note;
DROP TABLE IF EXISTS access;
DROP TABLE IF EXISTS board_tag;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS board;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE board (
    board_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    visibility ENUM('public', 'private') NOT NULL DEFAULT 'public',
    status ENUM('pending', 'opened', 'closed', 'removed') NOT NULL DEFAULT 'opened',
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_board_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tag (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE board_tag (
    board_id INT NOT NULL,
    tag_id INT NOT NULL,

    PRIMARY KEY (board_id, tag_id),

    CONSTRAINT fk_board_tag_board
        FOREIGN KEY (board_id)
        REFERENCES board(board_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_board_tag_tag
        FOREIGN KEY (tag_id)
        REFERENCES tag(tag_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE access (
    board_id INT NOT NULL,
    user_id INT NOT NULL,
    role ENUM('owner', 'editor', 'viewer') NOT NULL DEFAULT 'viewer',

    PRIMARY KEY (board_id, user_id),

    CONSTRAINT fk_access_board
        FOREIGN KEY (board_id)
        REFERENCES board(board_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_access_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE note (
    note_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    board_id INT NOT NULL,
    note_name VARCHAR(255) NOT NULL,
    note_content TEXT NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visibility ENUM('public', 'private') NOT NULL DEFAULT 'public',
    status ENUM('pending', 'opened', 'closed', 'removed') NOT NULL DEFAULT 'opened',

    CONSTRAINT fk_note_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_note_board
        FOREIGN KEY (board_id)
        REFERENCES board(board_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    board_id INT NULL,
    note_id INT NULL,
    parent_message_id INT NULL,
    anonymous BOOLEAN NOT NULL DEFAULT FALSE,
    anonymous_nickname VARCHAR(100),
    content TEXT NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'opened', 'closed', 'removed') NOT NULL DEFAULT 'opened',

    CONSTRAINT fk_message_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_message_board
        FOREIGN KEY (board_id)
        REFERENCES board(board_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_message_note
        FOREIGN KEY (note_id)
        REFERENCES note(note_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_message_parent
        FOREIGN KEY (parent_message_id)
        REFERENCES messages(message_id)
        ON DELETE SET NULL,

    CHECK (
        board_id IS NOT NULL OR note_id IS NOT NULL
    )
) ENGINE=InnoDB;