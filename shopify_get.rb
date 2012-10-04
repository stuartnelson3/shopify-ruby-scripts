require 'shopify_api'

# Get access to Shopify API
ShopifyAPI::Base.site = "https://[apikey-here]:[passkey-here]@example.myshopify.com/admin"

cust_array = [99084508,99084540,99084572,99084604,99084624]

cust_array.each do |id|
  customer = ShopifyAPI::Customer.find(id)
  puts customer.email
  [0,1,2,3].each do |index|
    puts customer.metafields[index].value unless customer.metafields[index].nil?
  end
end
