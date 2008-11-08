require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  should_ensure_logged_in(:get, :edit)
  should_ensure_logged_in(:put, :update, :user => {})

  logged_in do
    context "a User with a timezone" do
      setup do
        @timezone = 'Hawaii'
        @user.update_attributes(:timezone => @timezone)
      end

      context "GET to edit" do
        setup do
          get :edit
        end

        should "fill in the User's timezone as the default" do
          assert_select 'option[selected=selected][value=?]',
                        @timezone
        end
      end
    end

    context "a User without a timezone" do
      setup do
        @user.update_attributes(:timezone => nil)
      end

      context "GET to edit" do
        setup do
          get :edit
        end

        should "not pre-select a timezone" do
          assert_select 'option[selected=selected]', false
        end
      end
    end

    context "GET to edit" do
      setup do
        get :edit
      end

      should_render_template 'edit'

      should "have a form for their user info" do
        assert_select 'form[action=?][method=post]', account_path do
          assert_select 'input[type=hidden][name=_method][value=put]'
          assert_labeled_select 'input[type=text][name=?]',
                                "user[nickname]"
          assert_labeled_select 'input[type=text][name=?]',
                                "user[location]"
          assert_labeled_select 'select[name=?]', 'user[timezone]'
          assert_select 'input[type=submit]'
        end
      end

      should "have a form for their OpenID info" do
        assert_select 'form[action=?][method=post]', openid_path do
          assert_select 'input[type=hidden][name=_method][value=put]'
          assert_labeled_select 'input[type=text][name=?]',
                                'user[new_openid_identity]'
          assert_select 'input[type=submit]'
        end
      end
    end

    context "PUT to update" do
      context "with valid params" do
        setup do
          @valid_params = {:nickname => 'sarah', :timezone => 'Hawaii'}
          put :update, :user => @valid_params
          @user.reload
        end

        should_redirect_to 'edit_account_path'
        should_set_the_flash_to /updated/i

        should "update the fields as passed in" do
          @valid_params.each do |field, value|
            assert_equal value, @user.send(field)
          end
        end
      end

      context "with invalid timezone" do
        setup do
          @invalid_params = {:timezone => 'jkl'}
          put :update, :user => @invalid_params
          @user.reload
        end

        should_not_change 'User.find(@user)'
        should_redirect_to 'edit_account_path'
        should_set_the_flash_to /is not included in the list/
      end
    end
  end
end
