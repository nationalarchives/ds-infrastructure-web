import { test, expect, Cookie, Page } from "@playwright/test";

const createCookie: (name: string, value: string) => Cookie = (
  name,
  value,
) => ({
  name,
  value,
  domain: ".dblclk.dev",
  path: "/",
  expires: Date.now() / 1000 + 60000,
  httpOnly: false,
  secure: true,
  sameSite: "Lax",
});

const checkCookiesPolicy: (
  cookies: Array<Cookie>,
  essential: boolean,
  settings: boolean,
  usage: boolean,
  marketing: boolean,
) => void = (cookies, essential, settings, usage, marketing) => {
  const cookiesPolicy: Cookie | undefined = cookies.find(
    (cookie) => cookie.name === "cookies_policy",
  );
  expect(cookiesPolicy).toBeDefined();
  if (cookiesPolicy) {
    const cookiesPolicyValue = JSON.parse(
      decodeURIComponent(cookiesPolicy.value),
    );
    expect(cookiesPolicyValue?.essential).toEqual(essential);
    expect(cookiesPolicyValue?.settings).toEqual(settings);
    expect(cookiesPolicyValue?.usage).toEqual(usage);
    expect(cookiesPolicyValue?.marketing).toEqual(marketing);
  }
};

const checkTNAFrontendCookies: (page: Page) => void = async (page) => {
  const TNAFrontendCookies = await page.evaluate(
    () => window["TNAFrontendCookies"],
  );
  expect(TNAFrontendCookies).toBeDefined();
};

test("no cookies set", async ({ page, context }) => {
  await page.goto("/help/cookies/");

  expect(page.locator("h1")).toHaveText(/Cookies/);

  const cookieBanner = page.locator('[data-module="tna-cookie-banner"]');
  expect(cookieBanner).toHaveText(/This website uses cookies/);
  expect(cookieBanner).toBeVisible();

  const acceptCookiesButton = cookieBanner.locator('button[value="accept"]');
  expect(acceptCookiesButton).toHaveText(/Accept cookies/);
  expect(acceptCookiesButton).toBeVisible();

  const rejectCookiesButton = cookieBanner.locator('button[value="reject"]');
  expect(rejectCookiesButton).toHaveText(/Reject cookies/);
  expect(rejectCookiesButton).toBeVisible();

  const closeCookieBannerButtons = cookieBanner.locator(
    'button[value="close"]',
  );
  await expect(closeCookieBannerButtons).toHaveCount(2);
  (await closeCookieBannerButtons.all()).forEach((closeCookieBannerButton) => {
    expect(closeCookieBannerButton).toBeHidden();
  });

  const TNAFrontendCookies = await page.evaluate(
    () => window["TNAFrontendCookies"],
  );
  expect(TNAFrontendCookies).toBeDefined();

  await checkTNAFrontendCookies(page);
  checkCookiesPolicy(await context.cookies(), true, false, false, false);
});

test("cookie_policies and cookie_preferences_set set", async ({
  context,
  page,
}) => {
  await context.addCookies([
    createCookie("cookie_preferences_set", "true"),
    createCookie(
      "cookies_policy",
      "%7B%22usage%22%3Atrue%2C%22settings%22%3Atrue%2C%22marketing%22%3Atrue%2C%22essential%22%3Atrue%7D",
    ),
  ]);

  await page.goto("/");

  const cookieBanner = page.locator('[data-module="tna-cookie-banner"]');
  expect(cookieBanner).not.toBeVisible();

  await checkTNAFrontendCookies(page);
  checkCookiesPolicy(await context.cookies(), true, true, true, true);
});

test("cookie_policies set but no cookie_preferences_set cookie", async ({
  page,
  context,
}) => {
  await context.addCookies([
    createCookie(
      "cookies_policy",
      "%7B%22usage%22%3Atrue%2C%22settings%22%3Atrue%2C%22marketing%22%3Atrue%2C%22essential%22%3Atrue%7D",
    ),
  ]);

  await page.goto("/");

  const cookieBanner = page.locator('[data-module="tna-cookie-banner"]');
  expect(cookieBanner).toBeVisible();

  await checkTNAFrontendCookies(page);
  checkCookiesPolicy(await context.cookies(), true, true, true, true);
});

test("cookie_preferences_set set but no cookie_policies cookie", async ({
  page,
  context,
}) => {
  await context.addCookies([createCookie("cookie_preferences_set", "true")]);

  await page.goto("/");

  const cookieBanner = page.locator('[data-module="tna-cookie-banner"]');
  expect(cookieBanner).not.toBeVisible();

  await checkTNAFrontendCookies(page);
  checkCookiesPolicy(await context.cookies(), true, false, false, false);
});

test("invalid cookie_policies set with no cookie_preferences_set", async ({
  page,
  context,
}) => {
  await context.addCookies([createCookie("cookies_policy", "foobar")]);

  await page.goto("/");

  const cookieBanner = page.locator('[data-module="tna-cookie-banner"]');
  expect(cookieBanner).toBeVisible();

  await checkTNAFrontendCookies(page);
  checkCookiesPolicy(await context.cookies(), true, false, false, false);
});

test("invalid cookie_policies set with cookie_preferences_set", async ({
  page,
  context,
}) => {
  await context.addCookies([
    createCookie("cookies_policy", "foobar"),
    createCookie("cookie_preferences_set", "true"),
  ]);

  await page.goto("/");

  const cookieBanner = page.locator('[data-module="tna-cookie-banner"]');
  expect(cookieBanner).not.toBeVisible();

  await checkTNAFrontendCookies(page);
  checkCookiesPolicy(await context.cookies(), true, false, false, false);
});
