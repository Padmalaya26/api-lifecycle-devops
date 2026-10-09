const request = require("supertest");
const app = require("../src/app");

describe("Weather API", () => {

  test("should return weather details", async () => {

    const response = await request(app)
      .get("/weather/Stockholm");

    expect(response.statusCode).toBe(200);

    expect(response.body).toEqual({
      city: "Stockholm",
      temperature: 18,
      condition: "Cloudy"
    });

  });

});