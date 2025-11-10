require "mail"
require "dotenv/load"


options = {
  address: "smtp.zoho.com",
  port: "587",
  user_name: ENV["MY_EMAIL"],
  password: ENV["MY_PASS"],
  authentication: "plain",
  enable_starttls_auto: true
}

Mail.defaults do
  delivery_method :smtp, options
end

# This is a function which will send email to user (Notifiying user about changes and stuff)
def send_email(to, subject, body)
  Mail.deliver do
    from ENV["MY_EMAIL"]
    to to
    subject subject
    body body
  end
end