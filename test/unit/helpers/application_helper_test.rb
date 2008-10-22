require 'test_helper'
require 'action_view/test_case'

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @controller = TestController.new
    @request    = @controller.request
    stubs(:session).returns(@request.session)
  end

  logged_in do
    should "produce true when sent #logged_in?" do
      assert logged_in?
    end

    should "produce the user when sent #current_user" do
      assert_equal @user, current_user
    end
  end

  logged_out do
    should "produce false when sent #logged_in?" do
      assert ! logged_in?
    end

    should "produce nil when sent #current_user" do
      assert_nil current_user
    end
  end
end
