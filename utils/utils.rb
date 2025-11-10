module CryptonUtils
  class Response
    def self.send(bot, chat_id, message)
      bot.api.send_message(
        chat_id: chat_id,
        text: message
      )
    end
  end

  class Data
    def self.extract_symbol(message)
      _, symbol = message.text.split(" ")
      return symbol.upcase
    end
  end
end