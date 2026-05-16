function validateRequest(schema = {}) {
  return (req, res, next) => {
    const errors = [];

    validateSection("params", req.params, schema.params, errors);
    validateSection("query", req.query, schema.query, errors);
    validateSection("body", req.body, schema.body, errors);

    if (errors.length > 0) {
      res.status(400).json({
        message: "Validation failed",
        errors,
      });
      return;
    }

    next();
  };
}

function validateSection(sectionName, values, rules, errors) {
  if (!rules) {
    return;
  }

  Object.entries(rules).forEach(([field, rule]) => {
    const value = values[field];
    const fieldName = `${sectionName}.${field}`;

    if (value === undefined || value === null || value === "") {
      if (rule.required) {
        errors.push({
          field: fieldName,
          message: "This field is required",
        });
      }
      return;
    }

    if (rule.type && !matchesType(value, rule.type)) {
      errors.push({
        field: fieldName,
        message: `Expected ${rule.type}`,
      });
      return;
    }

    if (rule.enum && !rule.enum.includes(value)) {
      errors.push({
        field: fieldName,
        message: `Expected one of: ${rule.enum.join(", ")}`,
      });
    }

    if (rule.minLength && String(value).trim().length < rule.minLength) {
      errors.push({
        field: fieldName,
        message: `Must be at least ${rule.minLength} characters`,
      });
    }

    if (rule.maxLength && String(value).length > rule.maxLength) {
      errors.push({
        field: fieldName,
        message: `Must be at most ${rule.maxLength} characters`,
      });
    }
  });
}

function matchesType(value, type) {
  if (type === "number") {
    return Number.isFinite(Number(value));
  }

  if (type === "boolean") {
    return value === true || value === false || value === "true" || value === "false";
  }

  return typeof value === type;
}

module.exports = validateRequest;
