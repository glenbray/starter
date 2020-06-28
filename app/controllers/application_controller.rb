class ApplicationController < ActionController::Base
  include Pundit
  include Redirectable
  include Pagy::Backend

  before_action :authenticate_user!
end
