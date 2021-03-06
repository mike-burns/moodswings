require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @openid_identity = Factory.next(:openid_identity)
  end

  context "when authenticating with openid would succeed" do
    setup do
      @result = stub('successful_result',:successful? => true)
      @registration = {
        'nickname' => 'francis',
        'postcode' => '60647',
        'timezone' => 'Hawaii'
      }
      @controller.
        stubs(:authenticate_with_open_id).
        yields(@result, @openid_identity, @registration)
    end

    context "POST to create" do
      setup do
        post :create, :openid_identifier => @openid_identity
      end

      should_authenticate_with_openid

      before_should "not verify authenticity" do
        @controller.expects(:verify_authenticity_token).never
      end
    end

    context "authenticating as a first-time user" do
      setup do
        User.delete_all(:openid_identity => @openid_identity)
        get :create, :openid_identifier => @openid_identity
        @user = User.find_by_openid_identity(@openid_identity)
      end

      should_redirect_to('the account edit page') { edit_account_url }
      should_authenticate_with_openid
      should_log_user_in
      should_change 'User.count', :by => 1

      should "set the openid_identity" do
        assert_equal @openid_identity, @user.openid_identity
      end

      {:nickname => 'nickname', :location => 'postcode', :timezone => 'timezone'}.each do |field,sreg|
        should "set the #{field}" do
          assert_equal @registration[sreg], @user.send(field)
        end
      end
    end

    context "authenticating as a pre-existing user" do
      setup do
        Factory(:user, :openid_identity => @openid_identity)
        get :create, :openid_identifier => @openid_identity
        @user = User.find_by_openid_identity(@openid_identity)
      end

      should_redirect_to("the user's home page") { user_url(@user) }
      should_authenticate_with_openid
      should_log_user_in
    end
  end

  context "when authenticating with openid would fail" do
    setup do
      @message = 'no good'
      @result = stub('successful_result', :successful? => false,
                                          :message     => @message)
      @registration = {
        'nickname' => 'francis',
        'postcode' => '60647',
        'timezone' => 'Hawaii'
      }
      @controller.
        stubs(:authenticate_with_open_id).
        yields(@result, @openid_identity, @registration)
    end

    context "authenticating" do
      setup do
        get :create, :openid_identifier => @openid_identity
      end

      should_set_the_flash_to 'no good'
      should_redirect_to('the home page') { root_url }
      should_authenticate_with_openid
      should_log_user_out
    end
  end

  context "DELETE to destroy" do
    setup do
      @request.session[:user_id] = 1
      delete :destroy
    end
    
    should_redirect_to('the home page') { root_url }
    should_log_user_out
  end
end
