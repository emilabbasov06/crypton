require "dotenv/load"


class CryptonAPI
  def initialize
    @key = ENV["API_KEY"]
  end

  def get_data(symbol)
    puts "Symbol: #{symbol}"
  end
end