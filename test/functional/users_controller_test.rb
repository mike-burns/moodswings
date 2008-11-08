require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context "a User with Moods" do
    setup do
      @the_user = Factory(:user)
      Factory(:mood, :name => 'horny', :user => @the_user)
      Factory(:mood, :name => 'depressed', :user => @the_user)
    end

    logged_out do
      context "GET to show" do
        setup do
          get :show, :id => @the_user.to_param
        end

        should_assign_to :user, :equals => '@the_user'
        should_assign_to :moods, :equals => '@the_user.moods.first(10)'

        should "show some moods" do
          @the_user.moods.first(10).each do |mood|
            assert_select 'li', /#{mood.name}/
          end
        end

        should "not show the form" do
          assert_select 'form[action=?][method=post]', moods_path, false
        end

        should "not let you delete a mood" do
          assert_no_match %r{Delete}, @response.body
        end
      end
    end

    context "logged in as the moody user" do
      setup { login_as(@the_user) }

      context "GET to show" do
        setup do
          get :show, :id => @the_user.to_param
        end

        should "have a form for adding a mood" do
          assert_select 'form[action=?][method=post]', moods_path do
            assert_select 'input[type=image]'
          end
        end

        should "the above might be an issue, because it doesn't stick
                the x,y into the moods param"

        should "let you delete each mood" do
          @the_user.moods.first(10).each do |mood|
            assert_match %r{#{mood_path(mood)}}, @response.body
          end
        end
      end
    end

    logged_in do
      context "GET to show" do
        setup do
          get :show, :id => @the_user.to_param
        end

        should "not let you delete a mood" do
          assert_no_match %r{Delete}, @response.body
        end
      end
    end
  end
end
