# frozen_string_literal: true

# This migration is a minimal example as the `contractors` table probably already exists
class CreateContractors < ActiveRecord::Migration[6.1]
  def change
    create_table :contractors, id: :uuid do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :country, null: false
      t.datetime :start_date
      t.references :role, null: false
      t.integer :hourly_rate
      t.integer :avg_hours
      # more columns exist here
      # ...
      t.timestamps
    end
  end
end
