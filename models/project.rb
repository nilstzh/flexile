# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :projects_contractors
  has_many :contractors, through: :projects_contractors

  validates :name, presence: true
  # status are included for illustration
  enum :status, %i[created in-rogress finished archived deleted]
end
