class Recipient < ApplicationRecord
  validates :award_list_id, :name, :address_line_1, :city, :state, :zip, presence: true
  validates :ein, uniqueness: true
end
