require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  logged_out do
    {:edit => [:get, {}], :update => [:put, {:user =>{}}]}.each do |action, (meth, args)|
      context "#{meth.to_s.upcase} to #{action}" do
        setup do
          send(meth, action, args)
        end

        should_redirect_to 'root_url'
        should_set_the_flash_to /sign/i
      end
    end
  end

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
          [:nickname, :openid_identity, :location].each do |field|
            assert_select 'label[for=?]', "user_#{field}"
            assert_select 'input[type=text][name=?]', "user[#{field}]"
          end
          assert_labeled_select 'select[name=?]', 'user[timezone]'
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

      context "changing the OpenID" do
        should_eventually "re-evaluate"
      end

      context "with invalid timezone" do
        should_eventually "error"
      end
    end
  end
end
