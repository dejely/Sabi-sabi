function requireAuth(req, res, next) {
  if (req.user) {
    next();
    return;
  }

  const error = new Error("Authentication required");
  error.statusCode = 401;
  next(error);
}

module.exports = {
  requireAuth,
};
