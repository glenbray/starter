class ApplicationController < ActionController::Base
  include Pundit
  include Redirectable

  # before_action :authenticate_user!
end
