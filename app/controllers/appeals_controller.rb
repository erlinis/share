class AppealsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@appeals = current_user.appeals.where("is_accepted IS NULL")
	end

	def create
		@appeal = current_user.appeals.build(:receiver_id => params[:friend_id])
		if @appeal.save
			NewNotificationMailer.new_appeal(@appeal.user, @appeal.receiver).deliver
			flash[:notice] = 'Successfully Saved'
		else
			flash[:error] = "We couldn't save your request. Please try again"
		end
		redirect_to users_path
	end
end
