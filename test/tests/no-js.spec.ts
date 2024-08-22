import { test, expect } from "@playwright/test";

test.beforeEach(async ({ context }) => {
  // Block any css requests for each test in this file.
  await context.route(/.js$/, (route) => route.abort());
});

test("loads page without js", async ({ page }) => {
  await page.goto("/");
  // await page.screenshot({ path: 'no-js.png', fullPage: true });
});
