const cors = require("cors");
const express = require("express");

const errorHandler = require("./middleware/errorHandler");
const apiRoutes = require("./routes");

const app = express();

app.use(
  cors({
    origin: process.env.CORS_ORIGIN || true,
    credentials: true,
  })
);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.json({
    name: "sabi-sabi-api",
    status: "ok",
  });
});

app.use("/api", apiRoutes);

app.use((req, res, next) => {
  const error = new Error(`Route not found: ${req.method} ${req.originalUrl}`);
  error.statusCode = 404;
  next(error);
});

app.use(errorHandler);

module.exports = app;
