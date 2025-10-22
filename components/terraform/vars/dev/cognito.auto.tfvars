create_cognito = false

userpool = "nationalarchives-user-pool"
client_name = "nationalarchives-client"
user_pool_domain = "dev-auth.nationalarchives.gov.uk"

nationalarchives_callback_url = [
    "https://dev-etna.nationalarchives.gov.uk/signin-oidc",
    "https://localhost:44362/signin-oidc",
    "https://localhost:65521/auth/signup/",
]
nationalarchives_logout_url = [
    "https://dev-etna.nationalarchives.gov.uk/",
    "https://localhost:44362/",
    "https://localhost:65521/",
]
