const express = require("express");

const boardController = require("./board.controller");
const validateRequest = require("../../middleware/validateRequest");

const router = express.Router();

router.get("/public", boardController.listPublicBoards);

router.get(
  "/:id",
  validateRequest({
    params: {
      id: { required: true, type: "number" },
    },
  }),
  boardController.getBoard
);

router.post(
  "/",
  validateRequest({
    body: {
      user_id: { required: true, type: "number" },
      title: { required: true, type: "string", minLength: 1, maxLength: 255 },
      content: { type: "string" },
      visibility: { type: "string", enum: ["public", "private"] },
      status: { type: "string", enum: ["pending", "opened", "closed", "removed"] },
    },
  }),
  boardController.createBoard
);

module.exports = router;
