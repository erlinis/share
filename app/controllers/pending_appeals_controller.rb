class PendingAppealsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@appeals = Appeal.where("receiver_id = :receiver and is_accepted IS NULL", receiver: current_user.id)
	end

	def update
		@appeal = Appeal.find(params[:id])
		if @appeal.update_attributes(params[:appeal])
			flash[:notice] = "New Friend Added"
		else
			flash[:error] = @appeal.errors.full_messages.to_sentence
		end
		redirect_to action: :index
	end
end
