function errorHandler(error, req, res, next) {
  const statusCode = error.statusCode || error.status || 500;
  const response = {
    message: statusCode === 500 ? "Internal server error" : error.message,
  };

  if (error.errors) {
    response.errors = error.errors;
  }

  if (process.env.NODE_ENV === "development") {
    response.stack = error.stack;
  }

  res.status(statusCode).json(response);
}

module.exports = errorHandler;
