function requireRole(...allowedRoles) {
  return (req, res, next) => {
    const userRole = req.user && req.user.role;

    if (allowedRoles.includes(userRole)) {
      next();
      return;
    }

    const error = new Error("You do not have permission to perform this action");
    error.statusCode = 403;
    next(error);
  };
}

module.exports = {
  requireRole,
};
