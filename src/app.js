const express = require("express");

const app = express();

app.get("/weather/:city", (req, res) => {
  res.status(200).json({
    city: req.params.city,
    temperature: 18,
    condition: "Cloudy"
  });
});

module.exports = app;