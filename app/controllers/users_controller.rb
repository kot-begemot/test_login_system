class UsersController < ApplicationController

  before_filter :limited_for_authorized!, only: [:new, :create]

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user] = {id: @user.id, auth_token: @user.generate_auth_token!}
        format.html { redirect_to main_welcome_url, notice: 'User was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

#  # GET /users/1/edit
#  def edit
#    @user = User.find(params[:id])
#  end
#  
#  # GET /users/1
#  # GET /users/1.json
#  def show
#    @user = User.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#    end
#  end
#
#  # PUT /users/1
#  # PUT /users/1.json
#  def update
#    @user = User.find(params[:id])
#
#    respond_to do |format|
#      if @user.update_attributes(params[:user])
#        format.html { redirect_to @user, notice: 'User was successfully updated.' }
#      else
#        format.html { render action: "edit" }
#      end
#    end
#  end
#
#  # DELETE /users/1
#  # DELETE /users/1.json
#  def destroy
#    @user = User.find(params[:id])
#    @user.destroy
#
#    respond_to do |format|
#      format.html { redirect_to main_index_url }
#    end
#  end
end
