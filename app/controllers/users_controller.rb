class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def index
    @admins = User.where(admin: true)
    @users = User.where(admin: false)
  end
end
