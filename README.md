few files to work with the shopify api

shopify_to_gdoc.rb:

authenticates with shopify, then takes the fields of interest from the customers indentified by their 
ids in the gdoc spreadsheet and matches those fields with the names. if a customer doesn't have a
certain field, skip over it.

shopify_get.rb:

checks a few customers to see if their data was correctly updated in shopify

shopify_update.rb:

use mechanize gem to update a form that updates customer data
