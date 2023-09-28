class Filing < ApplicationRecord
  validates :filer_id, :tax_period_end_date, :return_timestamp, presence: true
end
