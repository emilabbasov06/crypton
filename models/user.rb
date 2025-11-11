require "active_record"


class User < ActiveRecord::Base
  self.primary_key = "telegram_id"

  validates :telegram_id, presence: true, uniqueness: true
  has_many :watchlists, foreign_key: "user_telegram_id" , dependent: :destroy
  has_many :alerts, foreign_key: "user_telegram_id", primary_key: "telegram_id", dependent: :destroy
end