class SessionController < ApplicationController
  before_filter :authorize!, only: :destroy
  before_filter :limited_for_authorized!, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_login(params[:user][:login])

    respond_to do |format|
      if @user && @user.crypted_password == params[:user][:password]
        session[:user] = {id: @user.id, auth_token: @user.generate_auth_token!}
        format.html { redirect_to main_welcome_path, notice: "Welcome, #{@user.login}!" }
      else
        flash.now[:alert] = "Login or password did not match."
        format.html { render action: :new }
      end
    end
  rescue
    redirect_to_authorization "Login failed. You might have submit malformed data."
  end

  def destroy
    respond_to do |format|
      current_user.delete_auth_token!
      session[:user].clear
      format.html { redirect_to main_index_path, notice: "You are logged out!" }
    end
  end
end
