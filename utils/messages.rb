module CryptonMessages
  START = <<~MSG
    👋 Hi there!

    Welcome to *Crypton Bot* — your personal crypto assistant.
    
    You can use me to:
    - Track prices of your favorite coins
    - Set alerts for price targets
    - Convert between cryptocurrencies
    - Manage your watchlist

    Type /help to see all available commands.
  MSG

  HELP = <<~MSG
    🆘 *Crypton Bot Commands*

    /start - Start interacting with the bot
    /help - Show this help message
    /ping - Check if bot is alive
    /price SYMBOL - Get current price of a coin (e.g., /price BTC)
    /convert FROM TO AMOUNT - Convert crypto (e.g., /convert BTC ETH 0.5)
    /watch SYMBOL - Add coin to your watchlist
    /unwatch SYMBOL - Remove coin from watchlist
    /list - Show your watchlist
    /alert SYMBOL PRICE DIRECTION - Add price alert (e.g., /alert BTC 50000 above)
    /unalert SYMBOL PRICE DIRECTION - Remove a price alert
    /alerts - Show all your active alerts
  MSG
end