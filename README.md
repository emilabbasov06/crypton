# Crypton Telegram Bot 🚀

**Crypton** is a feature-rich Telegram bot built in Ruby that allows crypto enthusiasts to track prices, set alerts, manage a watchlist, and convert cryptocurrencies in real-time.  

---

## 🔹 Features

- 📊 **Real-time price tracking** for Bitcoin, Ethereum, and other cryptocurrencies  
- ⏰ **Custom price alerts** — get notified when a coin reaches your target  
- 👀 **Watchlist management** — keep track of your favorite coins  
- 💱 **Crypto conversion** — convert between different cryptocurrencies  
- 🛠 **User-friendly commands** via Telegram  

---

## 🛠 Tech Stack

- **Language:** Ruby  
- **Database:** SQLite3 with ActiveRecord ORM  
- **APIs:** Custom API integration for crypto price data  
- **Bot Framework:** `telegram-bot-ruby`  

---

## ⚡ Installation

1. **Clone the repository**  

```bash
git clone https://github.com/emilabbasov06/crypton.git
cd crypton
```

2. **Install dependencies**

```bash
bundle install
```

3. **Set environment variables**

```bash
BOT_TOKEN=
BOT_NAME=
BOT_USERNAME=
MY_EMAIL=
MY_PASS=
API_KEY=
API_URL=
```

4. **Run the bot**

```bash
ruby main.rb
```

---

## 💬 Commands

| Command | Description |
|---------|-------------|
| /start | Start interacting with the bot |
| /help | Show available commands |
| /ping | Check if bot is alive |
| /price SYMBOL | Get current price of a coin (e.g., /price BTC) |
| /convert FROM TO AMOUNT | Convert crypto (e.g., /convert BTC ETH 0.5) |
| /watch SYMBOL | Add coin to your watchlist |
| /unwatch SYMBOL | Remove coin from your watchlist |
| /list | Show your watchlist |
| /alert SYMBOL PRICE DIRECTION | Add price alert (e.g., /alert BTC 50000 above) |
| /unalert SYMBOL PRICE DIRECTION | Remove a price alert |
| /alerts | Show all your active alerts |

---

## 📂 Project Structure

```bash
crypton/
├── api
│   └── api.rb
├── db
│   └── setup.rb
├── Gemfile
├── Gemfile.lock
├── helpers
│   ├── alert.rb
│   └── http.rb
├── mailers
│   └── notify_user.rb
├── main.rb
├── models
│   ├── alert.rb
│   ├── user.rb
│   └── watchlist.rb
├── README.md
└── utils
    ├── messages.rb
    └── utils.rb
```

---

## 🔗 Links

- GitHub Repository: https://github.com/emilabbasov06/crypton