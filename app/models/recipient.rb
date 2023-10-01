class Recipient < ApplicationRecord
  validates :name, :address_line_1, :city, :state, :zip, presence: true

  has_many :award_list
end
