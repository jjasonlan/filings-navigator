class AwardListsController < ApplicationController
  def index
    award_lists = AwardList.left_joins(:filing)
                            .left_joins(:recipient)
                            .where({filing: params[:filing_id] })
                            .select('award_lists.*, recipients.*')
    render json: award_lists
  end
end
