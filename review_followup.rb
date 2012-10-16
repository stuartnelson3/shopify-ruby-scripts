require 'gmail'
require 'google_drive'

# log into gmail
gmail = Gmail.connect("[email]", "[password]")

# Log into GoogleDrive
session = GoogleDrive.login("[email]", "[password]")

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=[key]
ws = session.spreadsheet_by_key("[key]").worksheets[0]

# clean up rows formatted from other spreadsheet
# b = (29..43).to_a
# b.each {|element| ws[element, 3] = ws[element, 3].split("-").first.strip}

# hash to take product names and get back urls
@product_urls = Hash.new
@product_urls[:ansleydress] = 100645392
@product_urls[:elliottblazer] = 100645402
@product_urls[:elliottcigarrettepant] = 100645426
@product_urls[:chloeshirt] = 100645416
@product_urls[:rileycigarettepant] = 100645428
@product_urls[:kennedyblouse] = 100645414
@product_urls[:fionablouse] = 100645420
@product_urls[:janejacket] = 100645406
@product_urls[:rileypencilskirt] = 100645438
@product_urls[:rileyblazer] = 100646236
@product_urls[:rileysheathdress] = 100645398
@product_urls[:emmajacket] = 100645412
@product_urls[:elliottpencilskirt] = 100645434
@product_urls[:chelseablazer] = 100645404
@product_urls[:elliottsheathdress] = 100645396
@product_urls[:elliottsheathskirt] = 100645430
@product_urls[:elliotttrouser] = 100645424

# interpolate ids into url
def url(id)
  return "http://quincy.myshopify.com/apps/powerreviews/review.html?pr_page_id=#{id}&pr_source=email"
end

# change email template slightly depending
# on if customer bought one or more items
def single_or_plural(array)
  array.length > 1 ? "pieces you ordered" : array.first.capitalize
end

# returns elements name along with link
def generate_review_links(array)
  a = ""
  array.each do |element|
    # turn element into a symbol
    symbol = turn_to_symbol(element)
    # get the id for the corresponding value in product_url hash
    id = @product_urls[symbol]
    a += "<p>#{element.capitalize}:</p><a href='#{url(id)}'>#{url(id)}</a>"
  end
  return a
end

# removes any whitespace,
# splits into array on ",",
# and pushes resulting elements into empty array b as symbols
def turn_to_symbol(string)
  string.gsub(/\s+/, "").to_sym
end

# array of columns that gdrive gem pulls info from
followup = (2..8).to_a

followup.each do |user|
  unless ws[user, 4] == "Yes"
    # gives list of products
    products_bought = ws[user, 3].downcase
    # creates array, gets rid of leading and trailing whitespace
    product_array = products_bought.split(",").each {|e| e.strip!}
    links = generate_review_links(product_array)
    gmail.deliver do
      # pulls name address entered in row from followup array, column 1
      name = ws[user, 1]
      # pulls email address entered in row from followup array, column 2
      email = ws[user, 2]
      # start email
      to email
      subject "Will you do us a small favor?"
      html_part do
        content_type "text/html; charset=UTF-8"
        body "<p>#{name},</p>
              <p>We're so glad to hear that you love the #{single_or_plural(product_array)}.&nbsp;
              We'd really appreciate it if you could take 5 minutes to write a review for our website.&nbsp;
              Since we're a new brand, these reviews are incredibly helpful to customers.</p>
              <p>Here's a verified buyer link for the #{single_or_plural(product_array)}:</p>
              #{links}
              <p>Thank you so much for being one of our first customers!</p>
              <p>&mdash; The Quincy team</p>
        "
      end
    end
    ws[user, 4] = "Yes"
    ws.save()
    sleep 3
  end
end

