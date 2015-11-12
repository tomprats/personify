class UsersController < ApplicationController
  def index
    @users = search_users
    @users = @users.page(params[:page]) if params[:page]
    @users = @users.per(params[:limit]) if params[:limit]

    render json: @users, extra_attributes: params[:data]
  end

  def create
    @user = User.create(user_params)
    render json: @user
  end

  def show
    @user = User.find(params[:id])

    render json: @user, extra_attributes: params[:data]
  end

  private
  def search_users
    users = User.all

    user_attributes.each do |attr|
      users = users.where("%s ILIKE %s", attr, "$$%#{params[attr]}%$$") if params[attr]
    end

    users
  end

  def user_attributes
    [:email, :name, :birthday, :favorite_color]
  end

  def user_params
    params.require(:user).permit(user_attributes)
  end
end
