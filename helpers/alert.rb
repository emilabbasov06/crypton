require_relative "../api/api"
require_relative "../models/user"
require_relative "../models/alert"
require_relative "./http"
require "json"


class AlertChecker
  REQUEST_INTERVAL = 10

  def initialize(bot)
    @api = CryptonAPI.new
    @bot = bot
    @running_threads = {}
  end

  def start_for_user(user)
    return if @running_threads[user.telegram_id]

    puts "[INFO]: Starting new alert for <User ##{user.telegram_id}>"

    @running_threads[user.telegram_id] = Thread.new do
      loop do
        alerts = Alert.where(user_telegram_id: user.telegram_id, triggered: false)

        if alerts.empty?
          @running_threads.delete(user.telegram_id)
          puts "[INFO]: Stopping alert for <User ##{user.telegram_id}>"
          break
        end

        alerts.each do |alert|
          current_price = @api.get_data(alert.symbol)["symbols"].first["last"].to_f
          next unless current_price

          if triggered?(alert, current_price)
            alert.update(triggered: true)
            message = <<~MSG
              🚨 *Alert Triggered!*

              🔹 Symbol: #{alert.symbol}
              🔹 Direction: #{alert.direction.upcase}
              🔹 Target Price: $#{alert.target_price}
              🔹 Current Price: $#{current_price}

              ⚡ Take action now!
            MSG
            CryptonUtils::Response.send(@bot, user.telegram_id, message)

            alert.destroy
          end
        end
        sleep REQUEST_INTERVAL
      end
    end
  end

  private def triggered?(alert, current_price)
    case alert.direction
    when "above"
      current_price >= alert.target_price.to_f
    when "below"
      current_price <= alert.target_price.to_f
    end
  end
end