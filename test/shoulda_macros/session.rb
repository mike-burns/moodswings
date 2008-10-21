class Test::Unit::TestCase
  def self.logged_out(&block)
    context "Logged out" do
      setup { session[:user_id] = nil }
      merge_block(&block)
    end
  end

  def self.logged_in(&block)
    context "Logged in" do
      setup do
        @user = Factory(:user)
        session[:user_id] = @user.id
      end

      merge_block(&block)
    end
  end
end
