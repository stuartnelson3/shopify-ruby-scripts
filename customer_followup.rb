require 'gmail'
require 'google_drive'

# log into gmail
gmail = Gmail.connect("[email]@gmail.com", "[password]")

# Log into GoogleDrive
session = GoogleDrive.login("[email]@gmail.com", "[password]")

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=[spreadsheet-key]
ws = session.spreadsheet_by_key("[spreadsheet-key]").worksheets[0]

# array of columns that gdrive gem pulls info from
followup = (4..39).to_a

# send email
followup.each do |user|
  # pulls email address entered in row from followup array, column 2
  email = p ws[user, 2]
  # pulls email address entered in row from followup array, column 3
  name = p ws[user, 3]
  gmail.deliver do
    to email
    subject "Your Quincy order"
    text_part do
    body "Hi #{name},
  
We just wanted to check in and make sure you received your recent Quincy order.
  
We would love to hear back about how you are liking your recent purchase.
  
Thanks for your feedback and support!
  
Xo,
  
The Quincy Team"
    end
  end
  # writes "?" to column 4 in row corresponding to the user
  ws[user, 4] = "?"
  # saves changes to gdoc
  ws.save()
  sleep 3
end

