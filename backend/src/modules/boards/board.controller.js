const boardService = require("./board.service");

async function listPublicBoards(req, res, next) {
  try {
    const boards = await boardService.getPublicBoards();
    res.json({ data: boards });
  } catch (error) {
    next(error);
  }
}

async function getBoard(req, res, next) {
  try {
    const board = await boardService.getBoardById(req.params.id);

    if (!board) {
      res.status(404).json({ message: "Board not found" });
      return;
    }

    res.json({ data: board });
  } catch (error) {
    next(error);
  }
}

async function createBoard(req, res, next) {
  try {
    const board = await boardService.createBoard(req.body);
    res.status(201).json({ data: board });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  createBoard,
  getBoard,
  listPublicBoards,
};
