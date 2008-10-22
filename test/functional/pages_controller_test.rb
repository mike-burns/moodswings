require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  context 'A GET to #show' do
    %w().each do |page|
      context "with a :name parameter value of '#{page}'" do
        setup { get :show, :name => page }

        should_respond_with :success
        should_render_template page
      end 
    end 
  end 

  context 'A GET to #home' do
    setup { get :home }

    should_respond_with :success
    should_render_template 'home'

    should "have an OpenID login field" do
      assert_select 'form[action=?][method=post]', session_path do
        assert_select 'input[type=text][name=?]', 'openid_identity'
      end
    end
  end 

  should_eventually "handle this redirect" do
    logged_in do
      context "GET to #home" do
        setup { get :home }

        should_redirect_to 'user_path(@user)'
      end
    end
  end
end
