require 'test_helper'

class SubscriptionsControllerTest < ActionController::TestCase
  should_route :post, '/users/5/subscription',
    :controller => :subscriptions,
    :action => :create,
    :user_id => '5'
  should_route :delete, '/users/5/subscription',
    :controller => :subscriptions,
    :action => :destroy,
    :user_id => '5'

  should_ensure_logged_in :post, :create, :user_id => '5'
  should_ensure_logged_in :delete, :destroy, :user_id => '5'

  logged_in do
    setup do
      @other_user = Factory(:user)
    end

    context "on POST to create" do
      setup do
        post :create, :user_id => @other_user.to_param
      end

      should_redirect_to("the other user's page") { user_url(@other_user) }
      should_set_the_flash_to /subscribed/

      should "create a subscription between @user and @other_user" do
        assert Subscription.exists?(:subscriber_id => @user.to_param,
                                    :user_id => @other_user.to_param)
      end
    end

    context "on DELETE to destroy" do
      setup do
        @subscription = Factory(:subscription,
                                :user => @other_user,
                                :subscriber => @user)
        delete :destroy, :user_id => @other_user.to_param
      end

      should_redirect_to("the other user's page") { user_url(@other_user) }
      should_set_the_flash_to /unsubscribed/

      should "delete the subscription" do
        assert !Subscription.exists?(@subscription.to_param)
      end
    end
  end
end
