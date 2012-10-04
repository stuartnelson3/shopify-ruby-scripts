require 'shopify_api'
require 'httparty'
require 'google_drive'

# Get access to Shopify API
ShopifyAPI::Base.site = "https://[apikey-here]:[passkey-here]@example.myshopify.com/admin"

# Log into GoogleDrive
session = GoogleDrive.login("[email]@gmail.com", "[password]")

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=[spreadsheet-key]
ws = session.spreadsheet_by_key("[spreadsheet-key]").worksheets[0]

ids = (2..107).to_a

ids.each do |id|
  int_id = p ws[id, 1].to_i
  customer = ShopifyAPI::Customer.find(int_id)
  fields = (0..2).to_a
  fields.each do |field|
    unless customer.metafields[field].nil?   
      # add 4 to move to the left 4 columns and enter data in the right place
      ws[id, (field + 4)] = customer.metafields[field].value
      ws.save()
    end
  end
  # sleep 2 seconds to avoid making shopify mad by making too many api calls too quickly
  sleep 2
end










#ShopifyAPI::Base.site = "https://63853221c8f1fae9b9b25345b10ec9c8:5ac79471d7d5407d353e015717d6a49b@quincy.myshopify.com/admin"
# 
# ShopifyAPI::Session.setup({:api_key => '660269e3de794e73373ac11dd763137f', :secret => '49938a05a1c5fd9491a39ae23fc1fcd6'})
# 
# customer = ShopifyAPI::Customer.find(89266874)
# 
# order = ShopifyAPI::Order.find(141057904)
# 
# product = ShopifyAPI::Product.find(100645392)

# class ShopifyFile
#   include HTTParty
#   base_uri "http://fitquiz.quincyapparel.com"
#   format :plain
#   headers "Accept" => "text/plain"
#   
#   def self.update(id, bust, length)
#     params = { :shop => "quincy.myshopify.com", :cid => "#{id}", :value => "#{bust}", :fq_length => "#{length}" }
#     headers = { "Accept" => "text/plain", "Accept-Encoding" => "gzip", "Connection" => "keep-alive" }
#     self.post("/ufq.php", :query => params, :headers => headers)
#   end
# end

# url = "http://fitquiz.quincyapparel.com/ufq.php"
# hash = { :shop => "quincy.myshopify.com", :cid => "89266874", :value => "40AB", :fq_length => "Tall" }
# def self.update_fq(id, bust, length)
#   hash = { :shop => "quincy.myshopify.com", :cid => "#{id}", :value => "#{bust}", :fq_length => "#{length}" }
#   self.post(url, :query => hash)
# end

# ret = HTTParty.post(url, :query => hash)
# puts ret.format

# user = ShopifyFile.new
# ShopifyFile.update("89266874", "40AB", "Tall")
