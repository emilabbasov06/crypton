require "telegram/bot"
require "dotenv/load"
require_relative "./db/setup"
require_relative "./models/user"
require_relative "./models/watchlist"
require_relative "./utils/utils"
require_relative "./utils/email"
require_relative "./api/api"


class Bot
  def initialize
    @api = CryptonAPI.new

    Telegram::Bot::Client.run(ENV["BOT_TOKEN"]) do |bot|
      bot.listen do |message|
        begin
          user = User.find_or_create_by(telegram_id: message.from.id) do |user|
            user.first_name = message.from.first_name
            user.last_name = message.from.last_name
            user.username = message.from.username
          end

          case message.text
          when "/start"
            CryptonUtils::Response.send(bot, message.chat.id, "Hi, #{user.first_name} [@#{user.username}]")
          when "/help"
            CryptonUtils::Response.send(bot, message.chat.id, "Help response.")
          when "/ping"
            CryptonUtils::Response.send(bot, message.chat.id, "Pong!")
          when "/list"
            CryptonUtils::Response.send(bot, message.chat.id, list(user))
          when /^\/watch\b/
            CryptonUtils::Response.send(bot, message.chat.id, watch(user, message))
          when /^\/unwatch\b/
            CryptonUtils::Response.send(bot, message.chat.id, unwatch(user, message))
          when /^\/price\b/
            CryptonUtils::Response.send(bot, message.chat.id, price(message))
          else
            CryptonUtils::Response.send(bot, message.chat.id, "Help response.")
          end
        rescue => e
          puts "[ERROR]: #{e.message}"
          CryptonUtils::Response.send(bot, message.chat.id, "❌ Something went wrong.")
        end
      end
    end
  end

  private def list(user)
    items = user.watchlists.pluck(:symbol)
    if items.empty?
      "📭 Your watchlist is empty."
    else
      "👀 Your watchlist:\n" + items.join(", ")
    end
  end

  private def price(message)
    _, symbol = message.text.split(" ")
    symbol.upcase!

    data = @api.get_data(symbol)["symbols"].first
    <<~MSG
📊 *#{symbol} Price Update*  
💰 Price: $#{data["last"]}
📉 Lowest: $#{data["lowest"]}
📈 Highest: $#{data["highest"]}
📆 Date: #{data["date"]}
🌍 Exchange: #{data["source_exchange"]}
🔁 24hr Change: #{data["daily_change_percentage"].to_f.round(6)}%
    MSG
  end

  private def watch(user, message)
    _, symbol = message.text.split(" ")
    symbol.upcase!
    coin = Watchlist.find_or_create_by(user: user, symbol: symbol)
    
    if coin.persisted?
      "✅ Added #{symbol} to your watchlist."
    else
      "⚠️ Could not add #{symbol} to your watchlist."
    end
  end

  private def unwatch(user, message)
    _, symbol = message.text.split(" ")
    symbol.upcase!
    coin = Watchlist.find_by(user: user, symbol: symbol)
    coin.destroy if coin

    "❌ Removed #{symbol} from your watchlist!"
  end

end

bot = Bot.new
bot