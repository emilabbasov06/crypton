require "active_record"


class Alert < ActiveRecord::Base
  belongs_to :user, foreign_key: "user_telegram_id", primary_key: "telegram_id"

  validates :user_telegram_id, :symbol, :target_price, :direction, presence: true
  validates :direction, inclusion: { in: ["above", "below"] }
end