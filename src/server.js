console.log("Starting server...");

const app = require("./app");

console.log("App loaded successfully");

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});