class RecipientsController < ApplicationController
  def index
    render json:Recipient.all.order("id ASC")
  end
end
