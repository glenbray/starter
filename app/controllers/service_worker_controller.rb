class ServiceWorkerController < ActionController::Base
  protect_from_forgery except: :service_worker

  def service_worker
  end

  def manifest
  end
end
