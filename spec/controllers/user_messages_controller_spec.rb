require 'spec_helper'

describe UserMessagesController do

  context "without an authenticated user " do
    describe "should redirect to sing_in when not logged in " do
      let(:user_message) { FactoryGirl.create(:user_message)}
      let(:user_message_attr) { FactoryGirl.attributes_for(:user_message)}

      it "should not have a current_user" do
        subject.current_user.should be_nil
      end

      it "should redirect to sing_in when request /user_message/new without logged in" do
        get :new
        response.should redirect_to new_user_session_path
      end

      it "should redirect to sing_in when request /user_message/show without logged in" do
        get :show, :id => user_message
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

  context "with an authenticated user " do
    login_user

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

    describe "GET 'index'" do
      it "returns http success" do
        get :index
        response.should be_success
      end

      it "should render index page" do
        get :index
        response.should render_template :index
      end

      # it "should returns user_messages created" do
      #   user_message = FactoryGirl.create(:user_message, user: subject.current_user)
      #   get :index
      #   expect(assigns(:user_messages)).to eq([user_message])
      # end

      it "should returns only the user_messages from the current user and friends' " do
        user = FactoryGirl.create(:user)
        user_message = FactoryGirl.create(:user_message, user: subject.current_user)
        user_message2 = FactoryGirl.create(:user_message, user: user, message: "some text")
        request = FactoryGirl.create(:appeal, user: subject.current_user, receiver_id: user.id, is_accepted: true)
        get :index
        ids = assigns(:user_messages).collect{ | message | message.user.id }
        ids.should include(user.id, subject.current_user.id)
      end

      # it "should returns only the user_messages from the current user " do
      #   user_message = FactoryGirl.create(:user_message, user: subject.current_user)
      #   user_message_other_user = FactoryGirl.create(:user_message)
      #   get :index
      #   users_ids = assigns(:user_messages).collect{ |um| um.user.id }
      #   expect(users_ids).to eq([subject.current_user.id])
      # end
    end

    describe "get GET 'new'" do
      it "should render new page" do
        get :new
        response.should render_template :new
      end

       it "should return a new instance of user_message" do
        get :new
        assigns(:user_message).instance_of?(UserMessage).should == true
      end
    end

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

        it "should redirect to index page after a successful creation " do
          post :create, user_message: @valid_user_message_attr
          response.should redirect_to '/user_messages'
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
      context "when messages belongs to current user " do
        before(:each) do
          @user_message = FactoryGirl.create(:user_message, user: subject.current_user)
           get :show, id:@user_message
        end

        it "should exist the user_message" do
          assigns(:user_message).should_not be_nil
        end

        it "should find the user_message to show" do
          assigns(:user_message).should == @user_message
        end

        it "should render show page" do
          response.should render_template :show
        end
      end

      context "when messages don't belongs to current user " do
        before(:each) do
          @user_message_any_user = FactoryGirl.create(:user_message)
        end

        it "should responde with 404 error because don't got the message" do
          get :show, id:@user_message_any_user
          response.response_code.should == 404
        end
      end
    end


    describe "on GET 'edit'" do
      context "when messages belongs to current user " do
        before(:each) do
          @user_message = FactoryGirl.create(:user_message, user: subject.current_user)
          get :edit, id:@user_message
        end

        it "should exist the user_message" do
          assigns(:user_message).should_not be_nil
        end

        it "should find the user_message to edit" do
          assigns(:user_message).should == @user_message
        end

        it "should render edit page" do
          response.should render_template :edit
        end
      end

      context "when messages don't belongs to current user " do
        before(:each) do
          @user_message_any_user = FactoryGirl.create(:user_message)
        end

        it "should responde with 404 error because not found the message" do
          get :edit, id:@user_message_any_user
          response.response_code.should == 404
        end
      end

      context "when user_message doesn't exist" do
        it "should responde with 404 error because not found the message" do
          get :edit, id: 999
          response.response_code.should == 404
        end
      end

    end


     describe "on PUT 'update'" do
      context "when messages belongs to current user " do
        before(:each) do
          @user_message = FactoryGirl.create(:user_message, user: subject.current_user)
          put :update, id:@user_message
        end

        it "should exist the user_message to edit" do
          assigns(:user_message).should_not be_nil
        end

        it "should return the updated user_message" do
          put :update, id:@user_message, user_message: FactoryGirl.attributes_for(:user_message, message: "new message")
          @user_message.reload
          @user_message.message.should eq("new message")
        end

        it "should return a flash notice to notify the successful action" do
          flash[:notice].should eq("Message updated!")
        end

        it "should redirect to show page after update" do
          response.should  redirect_to "/user_messages/#{@user_message.id}"
        end

        context "with invalid data" do
          before(:each) do
            @invalid_user_message = FactoryGirl.create(:user_message)
          end

          it "should redirect to template edit to correct the data" do
             put :update, id:@user_message, user_message: FactoryGirl.attributes_for(:user_message, message: nil)
             response.should render_template :edit
          end
        end
      end

      context "when messages don't belongs to current user " do
        before(:each) do
          @user_message_any_user = FactoryGirl.create(:user_message)
        end
        it "should responde with 404 error because not found the message" do
            put :update, id:@user_message_any_user
            response.response_code.should == 404
        end
      end

      context "when user_message trying to update doesn't exist" do
        it "should responde with 404 error because not found the message" do
          put :update, id: 999
          response.response_code.should == 404
        end
      end

    end

    describe "on DELETE 'destroy'" do
      context "when messages belongs to current user " do
        before(:each) do
          @user_message = FactoryGirl.create(:user_message, user: subject.current_user)
        end

        it "should delete the user_message " do
          expect{
            delete :destroy, id: @user_message
          }.to change(UserMessage,:count).by(-1)
        end

        it "should return a flash notice to notify the successful destroy" do
          delete :destroy, id:@user_message
          flash[:notice].should eq('Message destroyed!')
        end

        it "should redirect to index page after a successful destroy " do
          delete :destroy, id: @user_message
          response.should redirect_to '/user_messages'
        end
      end

      context "when user_message to destroy doesn't exist " do
        it "should responde with 404 error because not found the message" do
          delete :destroy, id: 999
          response.response_code.should == 404
        end
      end

    end
  end

end
