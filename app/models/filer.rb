class Filer < ApplicationRecord
  validates :name, :address_line_1, :city, :state, :zip, presence: true
  validates :ein, uniqueness: true

  has_many :filings
end
