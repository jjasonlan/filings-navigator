class Filing < ApplicationRecord
  validates :filer_id, :tax_period_end_date, :return_timestamp, presence: true

  belongs_to :filer
  has_many :award_lists
  has_many :recipients, through: :award_lists
end
