require "json"
require "dotenv/load"
require_relative "../helpers/http"


class CryptonAPI
  def initialize
    @conn = Http.new(ENV["API_URL"]).get_conn_with_headers(
      {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV["API_KEY"]}"
      }
    )
  end

  def get_data(symbol)
    response = @conn.get("getData", { symbol: symbol })

    if response.success?
      data = JSON.parse(response.body)
      return data
    else
      puts "[ERROR]: There was problem about fetching the data..."
    end
  end

  def get_conversion(from, to, amount)
    response = @conn.get("getConversion", {from: from.upcase, to: to.upcase, amount: amount})

    if response.success?
      data = JSON.parse(response.body)
      return data
    else
      puts "[ERROR]: There was a problem about fetching the data..."
    end
  end
end