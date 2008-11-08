require 'test_helper'

class MoodsControllerTest < ActionController::TestCase
  should_route :post, '/moods', :action => :create
  should_route :delete, '/moods/2', :action => :destroy, :id => 2

  should_ensure_logged_in :post, :create, :mood => {:name => 'thrilled'}
  should_ensure_logged_in :delete, :destroy, :id => 2

  logged_in do
    context "POST to create" do
      context "successfully" do
        setup do
          @valid_params = {:x => 10, :y => 10}
          post :create, :mood => @valid_params
          @mood = Mood.last
        end

        should_change 'Mood.count', :by => 1
        should_eventually "..." do
          should_redirect_to 'user_path(@user)'
        end

        should "set the mood's user to the current user" do
          assert_equal @user, @mood.user
        end
      end

      context "failed" do
        setup do
          @invalid_params = {}
          post :create, :mood => @invalid_params
        end

        should_not_change 'Mood.count'
        should_eventually "..." do
          should_redirect_to 'user_path(@user)'
        end
      end
    end

    context "a User's Mood" do
      setup do
        @mood = Factory(:mood, :user => @user)
      end

      context "DELETE to destroy" do
        setup do
          delete :destroy, :id => @mood.to_param
        end

        should_change 'Mood.count', :by => -1
        should_eventually "..." do
          should_redirect_to 'user_path(@user)'
        end
      end
    end

    context "another User's Mood" do
      setup do
        @mood = Factory(:mood)
      end

      context "DELETE to destroy" do
        setup do
          assert_raise(ActiveRecord::RecordNotFound) do
            delete :destroy, :id => @mood.to_param
          end
        end

        should_not_change 'Mood.count'
      end
    end
  end
end
