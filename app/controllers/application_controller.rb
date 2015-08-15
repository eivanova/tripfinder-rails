class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session,
          if: Proc.new { |c| c.request.format =~ %r{application/json} }

  before_filter :require_login

  before_action :set_locale

  def set_locale
    logger.error params[:locale]
    I18n.locale = params[:locale] || I18n.default_locale
  end

  private

  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
end
