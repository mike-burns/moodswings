require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @openid_identity = 'http://example.com/'
  end

  context "when authenticating with openid would succeed" do
    setup do
      @result = stub('successful_result',:successful? => true)
      @registration = {
        'nickname' => 'Francis',
        'postcode' => '60647',
        'timezone' => 'America/Los_Angeles'
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

      should_eventually("do something") { should_redirect_to 'user_path(@user)' }
      should_authenticate_with_openid
      should_log_user_in

      should "create an account" do
        assert_not_nil @user
      end

      should "set the name" do
        assert_equal @registration['nickname'], @user.nickname
      end

      should "set the location" do
        assert_equal @registration['postcode'], @user.location
      end
      
      should "set the timezone" do
        assert_equal @registration['timezone'], @user.timezone
      end
    end

    context "authenticating as a pre-existing user" do
      setup do
        Factory(:user, :openid_identity => @openid_identity)
        get :create, :openid_identifier => @openid_identity
        @user = User.find_by_openid_identity(@openid_identity)
      end

      should_eventually("do something") { should_redirect_to 'user_path(@user)' }
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
        'nickname' => 'Francis',
        'postcode' => '60647',
        'timezone' => 'America/Los_Angeles'
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
      should_redirect_to 'root_url'
      should_authenticate_with_openid

      should "not log the user in" do
        assert_nil session[:user_id]
      end
    end
  end
end
