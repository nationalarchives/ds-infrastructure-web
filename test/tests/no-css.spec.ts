import { test, expect } from "@playwright/test";

test.beforeEach(async ({ context }) => {
  // Block any css requests for each test in this file.
  await context.route(/.css$/, (route) => route.abort());
});

test("loads page without css", async ({ page }) => {
  await page.goto("/");
  // await page.screenshot({ path: 'no-css.png', fullPage: true });
});
