require_relative '../plugin.rb'

class Stock < Plugin
    TICKER_NAME_DATA = JSON.parse(File.read(File.join(__dir__, 'ticker-name.json')))

    SYMBOLS = ['AAPL', 'GOOGL', 'TSLA']

    def before_quadrant
      @data[:tickers] = SYMBOLS.map do |symbol|
        response = fetch(stock_url(symbol), headers, 1.hour)
        { 
          symbol: symbol, 
          name: ticker_name(symbol), 
          unit: currency_symbol('USD'),
          price: response.dig("last", 0).round(2),
          change: "#{(response.dig('changepct', 0).to_f * 100)&.round(2)}%"
        }
      end
    end

    def ticker_name(symbol) = TICKER_NAME_DATA[symbol]

    def currency_symbol(currency)
      {
        'USD' => '$',
        'EUR' => '€',
        'CAD' => '$',
        'CHF' => '₣',
        'GBP' => '£',
        'KRW' => '₩',
        'CNY' => '¥',
        'JPY' => '¥',
        'INR' => '₹'
      }[currency]
    end

    def stock_url(symbol) = "https://api.marketdata.app/v1/stocks/quotes/#{CGI.escape(symbol)}/"

    def headers
      {
        "Accept" => "application/json",
        "Authorization" => "Token #{ENV['STOCK_API_KEY']}"
      }
    end
  end