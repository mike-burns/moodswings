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

    should_eventually "have an OpenID login field"
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
