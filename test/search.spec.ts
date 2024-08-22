import { test, expect } from "@playwright/test";

test("perform a search", async ({ page }) => {
  const searchTerm = "ufo";
  await page.goto("/search/");
  // await expect(page).toHaveScreenshot();
  await expect(page.locator("#search-new")).toBeVisible();
  await expect(page.locator("#search-new")).toBeEditable();
  await page.locator("#search-new").fill(searchTerm);
  await page.locator("#search-new + button").click();
  await expect(page).toHaveTitle("Search - The National Archives");
  await page.getByRole("link").and(page.getByText("Catalogue results")).click();
  await expect(page).toHaveTitle(
    new RegExp(` results for "${searchTerm}" - Search - The National Archives`),
  );
  // await page.screenshot({ path: 'screenshot.png', fullPage: true });
});
