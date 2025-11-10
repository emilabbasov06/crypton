require "faraday"
require "json"
require "dotenv/load"


class CryptonAPI
  def initialize
    @conn = Faraday.new(
      url: ENV["API_URL"],
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV["API_KEY"]}"
      }
    )
  end

  def get_data(symbol)
    response = @conn.get("getData", { symbol: symbol })

    if response.success?
      data = JSON.pretty_generate(JSON.parse(response.body))
      return data
    else
      puts "[ERROR]: There was problem about fetching the data..."
    end
  end
end