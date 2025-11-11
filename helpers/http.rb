require "faraday"


class Http
  def initialize(url)
    @url = url
  end

  def get_conn
    Faraday.new(
      url: url
    )
  end

  def get_conn_with_headers(headers)
    Faraday.new(
      url: url,
      headers: headers
    )
  end
end