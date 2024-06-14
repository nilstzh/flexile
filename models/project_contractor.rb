# frozen_string_literal: true

class ProjectContractor < ApplicationRecord
  belongs_to :contractor
  belongs_to :project

  validates :rate, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
end
