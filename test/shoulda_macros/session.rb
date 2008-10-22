class Test::Unit::TestCase
  def self.logged_out(&block)
    context "Logged out" do
      setup { @request.session[:user_id] = nil }
      merge_block(&block)
    end
  end

  def self.logged_in(&block)
    context "Logged in" do
      setup do
        @user = Factory(:user)
        @request.session[:user_id] = @user.id
      end

      merge_block(&block)
    end
  end

  def self.should_authenticate_with_openid
    before_should "attempt to authenticate with openid" do
      @controller.
        expects(:authenticate_with_open_id).
        with(nil, :optional => [:nickname, :postcode, :timezone]).
        yields(@result, @openid_identity, @registration)
    end
  end

  def self.should_log_user_in
    should "log the user in" do
      assert_equal @user.id, session[:user_id]
    end      
  end

  def self.should_log_user_out
    should "log the user out" do
      assert_nil session[:user_id]
    end
  end
end
