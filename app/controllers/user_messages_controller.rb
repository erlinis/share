class UserMessagesController < ApplicationController
  
  def index
    @user_messages = UserMessage.all
  end

  def new
    @user_message = UserMessage.new
  end

  def create
    @user_message = UserMessage.new(params[:user_message])
    
    if @user_message.save
      flash[:notice] = 'Great, we will spread yours words!'
      redirect_to action: :index
    else
      flash[:error] = 'Hmm,it seems you forgot write something'
      render :action => :new
    end
  end

  def edit
    # code goes here
  end

  def udpate
    # code goes here
  end

  def destroy
    # code goes here
  end

end
