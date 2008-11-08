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
        @controller.stubs(:current_user).returns(@user)
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

  def self.should_ensure_logged_in(meth = nil, action = nil, args = {})
    if meth.nil?
      should_redirect_to 'root_url'
      should_set_the_flash_to /sign/i
    else
      logged_out do
        context "#{meth.to_s.upcase} to #{action}" do
          setup { send(meth, action, args) }
          should_ensure_logged_in
        end
      end
    end
  end
end
