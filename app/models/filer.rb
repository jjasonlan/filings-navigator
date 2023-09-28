class Filer < ApplicationRecord
  validates :filing_id, :name, :address_line_1, :city, :state, :zip, presence: true
  validates :ein, uniqueness: true
end
