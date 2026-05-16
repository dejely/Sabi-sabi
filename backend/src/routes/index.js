const express = require("express");

const boardRoutes = require("../modules/boards/board.routes");

const router = express.Router();

router.get("/health", (req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
  });
});

router.use("/boards", boardRoutes);

module.exports = router;
