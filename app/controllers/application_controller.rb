class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :default_layout

  class UnAuthorizedAccess < Exception; end
  class LimitedAccess < Exception; end

  rescue_from(ApplicationController::UnAuthorizedAccess) { redirect_to_authorization($!.message) }
  rescue_from(ApplicationController::LimitedAccess) { redirect_to_root($!.message) }

  def authorize!
    raise ApplicationController::UnAuthorizedAccess.new('Access to this resource is limited for authorized users.') if current_user.nil?
  rescue
    raise ApplicationController::UnAuthorizedAccess.new('Authorization filure.')
  end

  def limited_for_authorized!
    raise ApplicationController::LimitedAccess.new('Access to this resource is limited for authorized users.') if current_user
  rescue
    raise ApplicationController::LimitedAccess.new('Access filure.')
  end

  def redirect_to_authorization message
    respond_to do |format|
      flash[:alert] = message
      format.html { redirect_to login_url }
    end
  end

  def redirect_to_root message
    respond_to do |format|
      flash[:alert] = message
      format.html { redirect_to root_url }
    end
  end

  def current_user
    unless @current_user_loaded || session[:user].blank?
      user = User.find(session[:user][:id])
      @current_user = user.valid_auth_token?(session[:user][:auth_token]) ? user : nil
      @current_user_loaded ||= true
    end
    @current_user
  end

  protected

  def pjax?
    !!request.headers['X-PJAX']
  end
# hello
  def default_layout
    pjax? ? "content" : "application"
  end
end
