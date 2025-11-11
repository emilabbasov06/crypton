require "telegram/bot"
require "dotenv/load"
require_relative "./db/setup"
require_relative "./models/user"
require_relative "./models/watchlist"
require_relative "./models/alert"
require_relative "./utils/utils"
require_relative "./utils/messages"
require_relative "./api/api"
require_relative "./helpers/alert"


class Bot
  def initialize
    @api = CryptonAPI.new
    @alert_checker = AlertChecker.new(nil)

    Telegram::Bot::Client.run(ENV["BOT_TOKEN"]) do |bot|
      @alert_checker = AlertChecker.new(bot)

      User.all.each do |user|
        @alert_checker.start_for_user(user)
      end

      bot.listen do |message|
        begin
          user = User.find_or_create_by(telegram_id: message.from.id) do |user|
            user.first_name = message.from.first_name
            user.last_name = message.from.last_name
            user.username = message.from.username
          end

          case message.text
          when "/start"
            CryptonUtils::Response.send(bot, message.chat.id, CryptonMessages::START)
          when "/help"
            CryptonUtils::Response.send(bot, message.chat.id, CryptonMessages::HELP)
          when "/ping"
            CryptonUtils::Response.send(bot, message.chat.id, "Pong!")
          when "/list"
            CryptonUtils::Response.send(bot, message.chat.id, list(user))
          when "/alerts"
            CryptonUtils::Response.send(bot, message.chat.id, alerts(user))
          when /^\/watch\b/
            CryptonUtils::Response.send(bot, message.chat.id, watch(user, message))
          when /^\/unwatch\b/
            CryptonUtils::Response.send(bot, message.chat.id, unwatch(user, message))
          when /^\/alert\b/
            CryptonUtils::Response.send(bot, message.chat.id, alert(user, message))
            @alert_checker.start_for_user(user)
          when /^\/unalert\b/
            CryptonUtils::Response.send(bot, message.chat.id, unalert(user, message))
          when /^\/price\b/
            CryptonUtils::Response.send(bot, message.chat.id, price(message))
          when /^\/convert\b/
            CryptonUtils::Response.send(bot, message.chat.id, convert(message))
          else
            CryptonUtils::Response.send(bot, message.chat.id, CryptonMessages::HELP)
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

  private def alerts(user)
    items = user.alerts.pluck(:symbol)
    if items.empty?
      "📭 Your alert list is empty."
    else
      "👀 Your alerts:\n" + items.join(", ")
    end
  end

  private def convert(message)
    from, to, amount = CryptonUtils::Data.extract_multiple_params(message, 3)

    data = @api.get_conversion(from, to, amount)
    <<~MSG
      💱 Conversion Result

      #{amount} #{from.upcase} = #{data["result"].to_f.round(4)} #{to.upcase}
    MSG
  end

  private def price(message)
    symbol = CryptonUtils::Data.extract_symbol(message)

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
    symbol = CryptonUtils::Data.extract_symbol(message)
    coin = Watchlist.find_or_create_by(user: user, symbol: symbol)
    
    if coin.persisted?
      "✅ Added #{symbol} to your watchlist."
    else
      "⚠️ Could not add #{symbol} to your watchlist."
    end
  end

  private def unwatch(user, message)
    symbol = CryptonUtils::Data.extract_symbol(message)
    coin = Watchlist.find_by(user: user, symbol: symbol)
    coin.destroy if coin

    "❌ Removed #{symbol} from your watchlist!"
  end

  private def alert(user, message)
    symbol, target_price, direction = CryptonUtils::Data.extract_multiple_params(message, 3)

    alert = Alert.find_or_create_by(
      user: user, 
      symbol: symbol,
      target_price: target_price,
      direction: direction
    )

    if alert.persisted?
      "✅ Added #{symbol} to your alert list."
    else
      "⚠️ Could not add #{symbol} to your alert list."
    end
  end

  private def unalert(user, message)
    symbol, target_price, direction = CryptonUtils::Data.extract_multiple_params(message, 3)

    alert = Alert.find_by(user: user, symbol: symbol, target_price: target_price, direction: direction)
    alert.destroy if alert

    "❌ Removed #{symbol} from your alert list"
  end

end

bot = Bot.new
bot