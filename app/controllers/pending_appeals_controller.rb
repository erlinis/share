class PendingAppealsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@appeals = get_pending_appeals
		@appeals unless request.xhr?
	end

	def update
		@appeal = Appeal.find(params[:id])
		if @appeal.update_attributes(params[:appeal])
			@appeals = get_pending_appeals
			message = "New Friend Added" unless !@appeal.is_accepted
			redirect_to(action: :index, :notice => message) unless request.xhr?
		else
			redirect_to(action: :index, :error => @appeal.errors.full_messages.to_sentence) unless request.xhr?
		end
	end

	private
	def get_pending_appeals
		@appeals = Appeal.where("receiver_id = :receiver and is_accepted IS NULL", receiver: current_user.id) 
	end

end
