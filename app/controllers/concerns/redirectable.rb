# frozen_string_literal: true

module Redirectable
  extend ActiveSupport::Concern

  included do
    before_action :store_user_location!, if: :storable_location?
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || super
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? && !service_worker_controller?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def service_worker_controller?
    controller_name == "service_worker"
  end
end
