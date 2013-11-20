class UserMessagesController < ApplicationController

  before_filter :authenticate_user!

 def get_user_messages
    send_requests = Appeal.where("user_id = :user and is_accepted = true", user: current_user.id).map(&:receiver_id)
    received_requests = Appeal.where("receiver_id = :user and is_accepted = true", user: current_user.id).map(&:user_id)
    @user_messages = UserMessage.where(:user_id => [send_requests + received_requests << current_user.id ]).order("created_at DESC")
  end

  def index
    @user_messages = get_user_messages
    @user_message = UserMessage.new
  end

  def new
    @user_message = UserMessage.new
  end

  def create
    @user_message = UserMessage.new(params[:user_message])
    @user_message.user = current_user
    if @user_message.save
        user_messages = get_user_messages
        redirect_to(action: :index, :notice => 'Great, we will spread yours words!') unless request.xhr?
    else
      render(:action => :new) unless request.xhr?
    end

    # respond_to do |format|  
    #   if @user_message.save
    #     user_messages = get_user_messages
    #     format.html { redirect_to(@user_message, :notice => 'Great, we will spread yours words!') }  
    #     format.js 
    #   else
    #     format.html { render :action => "new", :error => 'Hmm,it seems you forgot write something' }  
    #     format.js
    #   end
    # end
  end

  def show
    @user_message = current_user.user_messages.find(params[:id])
  end

  def edit
    @user_message = current_user.user_messages.find(params[:id])
  end

  def update
    @user_message = current_user.user_messages.find(params[:id])
    if @user_message.update_attributes(params[:user_message])
      flash[:notice] = 'Message updated!'
      redirect_to @user_message
    else
      render :action => :edit
    end
  end

  def destroy
    @user_message = current_user.user_messages.find(params[:id])
    if @user_message.destroy
        user_messages = get_user_messages
        redirect_to(action: :index, :notice => 'Message destroyed!') unless request.xhr?
   #     flash[:notice] = 'Message destroyed!'
   #     redirect_to action: :index
    end
  end

end
