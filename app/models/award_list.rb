class AwardList < ApplicationRecord
  validates :filing_id, :filer_id, :recipient_id, :amount, :amended, presence: true
end
