-- Seed users

START TRANSACTION;

INSERT INTO users (user_id, username, email)
VALUES
(1, 'admin_user', 'admin@local.dev'),
(2, 'dejel', 'deasisdejel08@gmail.com'),
(3, 'rose', 'rkaindoy@up.edu.ph'),
(4, 'student_two', 'student2@local.dev');

-- Seed boards
INSERT INTO board (board_id, user_id, title, content, visibility, status)
VALUES
(1, 1, 'Public Announcements', 'General announcements for everyone.', 'public', 'opened'),
(2, 2, 'Lost and Found', 'Post lost and found items here.', 'public', 'opened'),
(3, 2, 'Private Study Notes', 'My personal collection of study notes.', 'private', 'opened'),
(4, 3, 'CMSC 127 Help Board', 'Ask questions about CMSC 127 here.', 'public', 'opened');

-- Seed tags
INSERT INTO tag (tag_id, tag_name)
VALUES
(1, 'announcement'),
(2, 'lost-and-found'),
(3, 'study'),
(4, 'cmsc127'),
(5, 'help');

-- Seed board_tag
INSERT INTO board_tag (board_id, tag_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 3),
(4, 4),
(4, 5);

-- Seed access roles
INSERT INTO access (board_id, user_id, role)
VALUES
(1, 1, 'owner'),
(2, 2, 'owner'),
(3, 2, 'owner'),
(3, 4, 'viewer'),
(4, 3, 'owner'),
(4, 2, 'editor');

-- Seed notes
INSERT INTO note (note_id, board_id, user_id, note_name, note_content, visibility, status)
VALUES
(1, 1, 1, 'Welcome to Sabi-Sabi', 'This is the official public board for announcements.', 'public', 'opened'),
(2, 2, 3, 'Lost Umbrella', 'I lost a black umbrella near the library.', 'public', 'opened'),
(3, 4, 2, 'Need help with SQL JOIN', 'Can someone explain INNER JOIN and LEFT JOIN?', 'public', 'opened'),
(4, 3, 2, 'Private Database Notes', 'Review normalization, ERD, and SQL constraints.', 'private', 'opened');

-- Seed messages / threads
INSERT INTO messages 
(message_id, user_id, board_id, note_id, parent_message_id, anonymous, anonymous_nickname, content, status)
VALUES
(1, 3, 1, 1, NULL, FALSE, NULL, 'Thank you for creating this board!', 'opened'),
(2, 4, 2, 2, NULL, TRUE, 'ConcernedStudent', 'I saw an umbrella near the cafeteria earlier.', 'opened'),
(3, 2, 4, 3, NULL, FALSE, NULL, 'INNER JOIN only returns matching rows from both tables.', 'opened'),
(4, 3, 4, 3, 3, FALSE, NULL, 'So LEFT JOIN includes unmatched rows from the left table?', 'opened'),
(5, 2, 4, 3, 4, FALSE, NULL, 'Yes, exactly.', 'opened');

COMMIT;