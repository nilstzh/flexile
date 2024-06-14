# frozen_string_literal: true

class CreateProjectsContractors < ActiveRecord::Migration[6.1]
  def change
    create_table :projects_contractors, id: false do |t|
      t.references :contractor, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.rate :integer, null: false, default: 0
      t.currency :string, null: false, default: 'USD'
      t.timestamps
    end

    add_index :projects_contractors, %i[contractor_id project_id]
  end
end
