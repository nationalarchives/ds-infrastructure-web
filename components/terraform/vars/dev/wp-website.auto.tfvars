service = "web"

deployment_s3_bucket               = "ds-dev-deployment-source"
logfile_s3_bucket                  = "ds-dev-logfiles"

resolver             = "10.128.208.2"
ups_appslb           = "test-apps.nationalarchives.web.local"
ups_legacy_apps      = "172.31.5.16"
ups_pronom           = "10.113.110.68"
ups_ecommerce_be     = "172.31.10.18"
ups_services         = "172.31.2.125"
ups_win2016apps      = "10.113.120.41"
ups_win2016apps_host = "test-apps.nationalarchives.gov.uk"
ups_win2016web       = "10.113.110.105"
ups_win2016web_host  = "test2016.nationalarchives.gov.uk"

on_prem_cidrs = [
    "172.31.2.0/24",
    "172.31.6.0/24",
    "172.31.10.0/24"
]


admin_list = [
    # Pulse VPN clients
    "85.115.52.0/23",
    "10.252.0.0/16",
    # Citrix
    "10.96.46.0/24",
    # Corporate Wi-Fi
    "10.106.16.0/21",
    # on-prem ???
    "137.221.134.222/32",
    # Karl Kern
    "82.26.43.116/32",
    # Matthew De Ville
    "2.103.0.179/32",
    # Nicola Wissbrock
    "86.170.127.250/32",
    # Andy Aldridge
    "82.42.147.52/32",
    # Annette Bowery - temp editor
    "92.234.59.229/32",
    # Simon 2024-07-17
    "86.147.251.17/32",
    # Saurabh 2024-07-17
    "62.56.19.212/32",
    # AJ 2026-02-24
    "109.153.100.149/32",
    # Vaishnavi 2026-03-19
    "86.182.65.98/32",
]

# site_access_list contains the list of IP ranges with access to the
# public website. It will be further filtered by WAF
site_access_list = [
    # on-prem
    "137.221.134.222/32",
    "85.115.52.201/32",
    # Pulse Secure
    "85.115.52.0/23",
    "10.252.16.0/24",
    # Nicola Wissbrock
    "86.170.127.250/32",
    # Annette Bowery - temp editor
    "92.234.59.229",
    # allow CloudFront IPs - currently any IP
    "0.0.0.0/0",
]

streamline_access_list = [
    "195.35.90.0/23"
    # streamline provided IP range
]


