class PendingRequestsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@requests = Request.where("receiver_id = :receiver", receiver: current_user.id)
	end

	def update
		@request = Request.find(params[:id])
		if @request.update_attributes(params[:request])
			flash[:notice] = "New Friend Added"
		else
			flash[:error] = @request.errors.full_messages.to_sentence
		end
		redirect_to action: :index
	end
end
