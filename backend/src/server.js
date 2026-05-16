require("dotenv").config({ quiet: true });

const app = require("./app");
const { testConnection } = require("./config/db");

const PORT = process.env.PORT || 3001;

async function startServer() {
  if (process.env.DB_HOST && process.env.DB_NAME) {
    try {
      await testConnection();
      console.log("Database connection ready");
    } catch (error) {
      console.warn(`Database connection failed: ${error.message}`);
    }
  } else {
    console.warn("Database connection check skipped: DB_HOST or DB_NAME is not set");
  }

  app.listen(PORT, () => {
    console.log(`Backend API running on http://localhost:${PORT}`);
  });
}

startServer();
