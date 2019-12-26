class ApplicationController < ActionController::API
  def authenticate_user!
    request.env['warden'].authenticate!
  end

  def current_user
    request.env['warden'].user
  end
end
