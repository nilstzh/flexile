# frozen_string_literal: true

class Contractor < ApplicationRecord
  has_one :role
  has_many :projects_contractors
  has_many :projects, through: :projects_contractors

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :country, presence: true
end
