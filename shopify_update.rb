require 'shopify_api'
require 'httparty'
require 'google_drive'
require 'mechanize'

# Get access to Shopify API
ShopifyAPI::Base.site = "https://[apikey-here]:[passkey-here]@example.myshopify.com/admin"

# Log into GoogleDrive
session = GoogleDrive.login("[email]@gmail.com", "[password]")

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=[spreadsheet-key]
ws = session.spreadsheet_by_key("[spreadsheet-key]").worksheets[0]

ids = (2..107).to_a

a = Mechanize.new
a.get('http://localhost:4567/')
page = a.get('http://localhost:4567/')
form = a.page.forms[0]
button = form.button_with(:value => "Submit")
form["cid"] = 89266874
form["bust"] = "38CD"
form["length"] = "Petite"
form["waist"] = 31
form.encoding = "utf-8"
a.click_button(page.forms.first)


