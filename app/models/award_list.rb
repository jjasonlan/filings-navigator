class AwardList < ApplicationRecord
  validates :filing_id, :recipient_id, :amount, presence: true

  belongs_to :filing
  belongs_to :recipient
end
