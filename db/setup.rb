require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/development.sqlite3"
)

unless ActiveRecord::Base.connection.table_exists?(:users)
  ActiveRecord::Schema.define do
    create_table :users, id: false do |table|
      table.primary_key :telegram_id
      table.string :first_name
      table.string :last_name
      table.string :username

      table.timestamps
    end
  end
end

unless ActiveRecord::Base.connection.table_exists?(:watchlists)
  ActiveRecord::Schema.define do
    create_table :watchlists do |table|
      table.integer :user_telegram_id, null: false
      table.string :symbol, null: false

      table.timestamps
    end

    add_foreign_key :watchlists, :users, column: :user_telegram_id, primary_key: :telegram_id
  end
end