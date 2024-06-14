# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.status :integer, null: false, default: 0
      t.timestamps
    end
  end
end
