const db = require("../../config/db");

function mapBoard(row) {
  return {
    board_id: row.board_id,
    user_id: row.user_id,
    username: row.username,
    title: row.title,
    content: row.content,
    visibility: row.visibility,
    status: row.status,
    date_created: row.date_created,
    tags: row.tags ? row.tags.split(",") : [],
  };
}

async function getPublicBoards() {
  const [rows] = await db.execute(`
    SELECT
      b.board_id,
      b.user_id,
      u.username,
      b.title,
      b.content,
      b.visibility,
      b.status,
      b.date_created,
      GROUP_CONCAT(DISTINCT t.tag_name ORDER BY t.tag_name SEPARATOR ',') AS tags
    FROM board b
    JOIN users u ON u.user_id = b.user_id
    LEFT JOIN board_tag bt ON bt.board_id = b.board_id
    LEFT JOIN tag t ON t.tag_id = bt.tag_id
    WHERE b.visibility = 'public'
      AND b.status = 'opened'
    GROUP BY
      b.board_id,
      b.user_id,
      u.username,
      b.title,
      b.content,
      b.visibility,
      b.status,
      b.date_created
    ORDER BY b.date_created DESC
  `);

  return rows.map(mapBoard);
}

async function getBoardById(boardId) {
  const [rows] = await db.execute(
    `
      SELECT
        b.board_id,
        b.user_id,
        u.username,
        b.title,
        b.content,
        b.visibility,
        b.status,
        b.date_created,
        GROUP_CONCAT(DISTINCT t.tag_name ORDER BY t.tag_name SEPARATOR ',') AS tags
      FROM board b
      JOIN users u ON u.user_id = b.user_id
      LEFT JOIN board_tag bt ON bt.board_id = b.board_id
      LEFT JOIN tag t ON t.tag_id = bt.tag_id
      WHERE b.board_id = ?
      GROUP BY
        b.board_id,
        b.user_id,
        u.username,
        b.title,
        b.content,
        b.visibility,
        b.status,
        b.date_created
    `,
    [boardId]
  );

  return rows[0] ? mapBoard(rows[0]) : null;
}

async function createBoard(boardData) {
  const {
    user_id,
    title,
    content = null,
    visibility = "public",
    status = "opened",
  } = boardData;

  const [result] = await db.execute(
    `
      INSERT INTO board (user_id, title, content, visibility, status)
      VALUES (?, ?, ?, ?, ?)
    `,
    [user_id, title.trim(), content, visibility, status]
  );

  return getBoardById(result.insertId);
}

module.exports = {
  createBoard,
  getBoardById,
  getPublicBoards,
};
