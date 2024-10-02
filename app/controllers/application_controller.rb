class ApplicationController < ActionController::Base
  before_action :configure_sign_out_for_turbo
  helper Chartkick::Helper
  private

  def configure_sign_out_for_turbo
    request.env["devise.skip_timeout"] = true if turbo_controller?
  end

  def turbo_controller?
    request.headers["Turbo-Frame"].present?
  end
end
