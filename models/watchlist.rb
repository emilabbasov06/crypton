require "active_record"

class Watchlist < ActiveRecord::Base
  belongs_to :user, foreign_key: "user_telegram_id", primary_key: "telegram_id"
  validates :symbol, presence: true
end