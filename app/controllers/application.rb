class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  include ApplicationHelper
  include HoptoadNotifier::Catcher
end
