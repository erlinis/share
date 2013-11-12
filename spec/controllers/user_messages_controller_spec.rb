require 'spec_helper'

describe UserMessagesController do

  context "without an authenticate_user " do
    describe "should redirect to sing_in when not logged in " do
      let(:user_message) { FactoryGirl.create(:user_message)}
      let(:user_message_attr) { FactoryGirl.attributes_for(:user_message)}
      # TODO: reseacrh what id does? after { response.should redirect_to new_user_session_path } 

      it "should not have a current_user" do
        subject.current_user.should be_nil
      end
      
      it "should redirect to sing_in when request /user_message/new without logged in" do
        get :new 
        response.should redirect_to new_user_session_path 
      end

      it "should redirect to sing_in when request /user_message/create without logged in" do
        post :create, :id => user_message_attr
        response.should redirect_to new_user_session_path 
      end

      it "should redirect to sing_in when request /user_message/:id/edit without logged in" do
        get :edit, :id => user_message
        response.should redirect_to new_user_session_path 
      end

      it "should redirect to sing_in when request /user_message/:id/update without logged in" do
        put :update, :id => user_message
        response.should redirect_to new_user_session_path 
      end

      it "should redirect to sing_in when request /user_message/:id/destroy without logged in" do
        delete :destroy, :id => user_message
        response.should redirect_to new_user_session_path 
      end
    end
  end

  context "with an authenticate user " do
    login_user

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end

      it "should returns user_messages created" do
        user_message = FactoryGirl.create(:user_message, user: subject.current_user)
        get 'index'
        expect(assigns(:user_messages)).to eq([user_message])
      end

      it "should returns only the user_messages from the current user " do
        user_message = FactoryGirl.create(:user_message, user: subject.current_user)
        user_message2 = FactoryGirl.create(:user_message, user: subject.current_user, message:"some text")
        get 'index'
        users_ids = assigns(:user_messages).collect{ |um| um.user.id }
        expect(users_ids).to eq([subject.current_user.id, subject.current_user.id])
      end

      it "should returns only the user_messages from the current user " do
        user_message = FactoryGirl.create(:user_message, user: subject.current_user)
        user_message_other_user = FactoryGirl.create(:user_message)
        get 'index'
        users_ids = assigns(:user_messages).collect{ |um| um.user.id }
        expect(users_ids).to eq([subject.current_user.id])
      end
    end

  end

  context "with an authenticate user " do
    login_user

    describe "on POST 'create'" do
      
      context "with valid data" do
        before(:each) do
          @valid_user_message_attr = FactoryGirl.attributes_for(:user_message, message: "some message")
        end
        it "should get correct params to create a new user_message" do
          post :create, user_message: @valid_user_message_attr
          assigns(:user_message).message.should == "some message"
        end

        it "should create an user_message" do 
          expect{
            post :create, user_message: @valid_user_message_attr
            assigns(:user_message)
          }.to change(UserMessage,:count).by(1)
        end

        it "should return successful user_message created" do
          post :create, user_message: @valid_user_message_attr
          assigns(:user_message)
          flash[:notice].should == 'Great, we will spread yours words!'
        end
      end

      context "with invalid data" do
        before(:each) do
          @invalid_user_message_attr = FactoryGirl.attributes_for(:invalid_user_message)
        end
        it "should redirect to template new to correct the data" do 
          post :create, invalid_user_message: @invalid_user_message_attr
          assigns(:invalid_user_message)
          flash[:error].should == 'Hmm,it seems you forgot write something'
        end

        it "should redirect to template new to correct the data" do 
          post :create, invalid_user_message: @invalid_user_message_attr
          assigns(:invalid_user_message)
          response.should render_template :new
        end
      end
    end
  
    describe "on GET 'show'" do
      before(:each) do
        @user_message = FactoryGirl.create(:user_message)
      end

      it "should exist the user_message" do 
        get :show, id:@user_message 
        assigns(:user_message).should_not be_nil
      end

       it "should find the user_message to show" do 
        get :show, id:@user_message 
        assigns(:user_message).should == @user_message
      end
    end

    describe "on GET 'edit'" do
      before(:each) do
        @user_message = FactoryGirl.create(:user_message)
      end

      it "should exist the user_message" do 
        get :edit, id:@user_message 
        assigns(:user_message).should_not be_nil
      end

      it "should find the user_message to edit" do 
        get :edit, id:@user_message 
        assigns(:user_message).should == @user_message
      end

      it "should raise a error when user_message doesn't exist" do 
        expect{
          get :edit, id: 999
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  

     describe "on PUT 'update'" do
      before(:each) do
        @user_message = FactoryGirl.create(:user_message)
      end

      it "should exist the user_message to edit" do 
        put :update, id:@user_message 
        assigns(:user_message).should_not be_nil
      end

      it "should raise a error when user_message to update doesn't exist" do 
        expect{
          put :update, id: 999
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should return the updated user_message" do 
        @user_message.message = "new message"
        put :update, id:@user_message 
        assigns(:user_message).should == @user_message
      end

      it "should return a flash notice to notify the successful action" do 
        @user_message.message = "new message"
        put :update, id:@user_message 
        flash[:notice].should eq("Message updated!")
      end
    end

    describe "on DELETE 'destroy'" do
      before(:each) do
        @user_message = FactoryGirl.create(:user_message)
      end
      
      it "should delete the user_message " do
        expect{ 
          delete :destroy, id: @user_message 
        }.to change(UserMessage,:count).by(-1)
      end

      it "should raise a error when user_message to delete doesn't exist " do 
        expect{
          delete :destroy, id: 999
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should return a flash notice to notify the successful destroy" do 
        @user_message.message = "new message"
        put :destroy, id:@user_message 
        flash[:notice].should eq('Message destroyed!')
      end

      it "should delete the image when the user_message is destroyed" do
        @user_message_with_image = FactoryGirl.create(:user_message_with_image)
        expect{
          delete :destroy, id: @user_message_with_image
          imagen_path = "/spec/fixtures/uploads/#{@user_message_with_image.image}"
          File.open(File.join(Rails.root, imagen_path))
        }.to raise_error(Errno::ENOENT)
      end

      it "should delete the directory image when the user_message is destroyed" do
        @user_message_with_image = FactoryGirl.create(:user_message_with_image)
        expect{
          delete :destroy, id: @user_message_with_image
          dir_path = "/spec/fixtures/uploads/user_message/image/#{@user_message_with_image.id}/"
          Dir.chdir(File.join(Rails.root, dir_path))
        }.to raise_error(Errno::ENOENT)
      end
    end
  end

end
