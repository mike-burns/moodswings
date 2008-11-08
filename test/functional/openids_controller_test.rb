require 'test_helper'

class OpenidsControllerTest < ActionController::TestCase
  def setup
    @openid_identity = Factory.next(:openid_identity)
  end

  should_route :get, '/openid', :controller => 'openids', :action => 'show'
  should_route :put, '/openid', :controller => 'openids', :action => 'update'

  should_ensure_logged_in(:get, :show)
  should_ensure_logged_in(:put, :update, :user => {:openid_identity => @openid_identity})

  logged_in do
    context "a User with new_openid_identity set" do
      setup do
        @user.update_attributes(:new_openid_identity => @openid_identity)
      end

      context "when authenticating with openid would succeed" do
        setup do
          @result = stub('successful_result',:successful? => true)
          @controller.stubs(:authenticate_with_open_id).
            with(@openid_identity).yields(@result, @openid_identity)
        end

        context "successful update_attributes" do
          setup do
            get :show
            @user.reload
          end

          before_should "attempt to authenticate with openid" do
            @controller.expects(:authenticate_with_open_id).
              with(@openid_identity).yields(@result, @openid_identity)
          end

          before_should "not verify authenticity" do
            @controller.expects(:verify_authenticity_token).never
          end

          should_redirect_to 'edit_account_path'

          should "set the User's openid_identity to the new_openid_identity" do
            assert_equal @openid_identity, @user.openid_identity
          end

          should "set the User's new_openid_identity to nil" do
            assert_nil @user.new_openid_identity
          end
        end

        context "failed update_attributes" do
          setup do
            @user.expects(:update_attributes).
              with(:openid_identity => @openid_identity,
                   :new_openid_identity => nil).returns(false)
            errors = mock('errors', :full_messages => ['invalid OpenID'])
            @user.expects(:errors).returns(errors)
            get :show
            @user.reload
          end

          before_should "attempt to authenticate with openid" do
            @controller.expects(:authenticate_with_open_id).
              with(@openid_identity).yields(@result, @openid_identity)
          end

          before_should "not verify authenticity" do
            @controller.expects(:verify_authenticity_token).never
          end

          should_redirect_to 'edit_account_path'
          should_set_the_flash_to /invalid/
          should_not_change '@user.openid_identity'
          should_not_change '@user.new_openid_identity'
        end
      end

      context "when authenticating with openid would fail" do
        setup do
          @message = 'no good'
          @result = stub('successful_result', :successful? => false,
                         :message     => @message)
          @controller.
            stubs(:authenticate_with_open_id).
            yields(@result, @openid_identity)
            get :show
            @user.reload
        end

        should_set_the_flash_to 'no good'
        should_redirect_to 'edit_account_path'
        should_not_change '@user.openid_identity'
        should_not_change '@user.new_openid_identity'
      end
    end

    context "PUT to update" do
      context "successful" do
        setup do
          put :update, :user => {:new_openid_identity => @openid_identity}
          @user.reload
        end

        should_not_change '@user.openid_identity'
        should_redirect_to 'openid_path'

        should "set the new_openid_identity" do
          assert_equal @openid_identity, @user.new_openid_identity
        end
      end

      context "failed" do
        setup do
          @invalid_params = {'new_openid_identity' => 'foo'}
          @user.expects(:update_attributes).with(@invalid_params).returns(false)
          errors = mock('errors', :full_messages => ['invalid OpenID'])
          @user.expects(:errors).returns(errors)
          put :update, :user => @invalid_params
        end

        should_set_the_flash_to /invalid/
        should_redirect_to 'edit_account_path'
      end
    end
  end
end
