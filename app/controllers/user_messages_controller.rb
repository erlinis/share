class UserMessagesController < ApplicationController
  
  before_filter :authenticate_user!
 
  def index
    @user_messages = current_user.user_messages
  end

  def new
    @user_message = UserMessage.new
  end

  def create
    @user_message = UserMessage.new(params[:user_message])
    @user_message.user = current_user
    if @user_message.save
      flash[:notice] = 'Great, we will spread yours words!'
      redirect_to action: :index
    else
      flash[:error] = 'Hmm,it seems you forgot write something'
      render :action => :new
    end
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
      flash[:notice] = 'Message destroyed!'
      redirect_to action: :index
    end
  end

end
