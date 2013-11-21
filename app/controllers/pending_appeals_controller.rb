class PendingAppealsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@appeals = Appeal.where("receiver_id = :receiver and is_accepted IS NULL", receiver: current_user.id) 
		@appeals unless request.xhr?
	end

	def update
		@appeal = Appeal.find(params[:id])
		if @appeal.update_attributes(params[:appeal])
			appeals = Appeal.where("receiver_id = :receiver and is_accepted IS NULL", receiver: current_user.id) 
			redirect_to(action: :index, :notice => "New Friend Added" ) unless request.xhr?
		else
			redirect_to(action: :index, :error => @appeal.errors.full_messages.to_sentence) unless request.xhr?
		end
	end
end
