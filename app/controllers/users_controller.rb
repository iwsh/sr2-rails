class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.select(:id, :name, :is_admin, :email, :fails_count)

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      if !params[:password].nil? && !params[:password].empty?
        params[:user][:password] = params[:password]
      end
      if !params[:password_confirmation].nil? && !params[:password_confirmation].empty?
        params[:user][:password_confirmation] = params[:password_confirmation]
      end
      params.require(:user).permit(:name, :is_admin, :password, :password_confirmation, :email, :fails_count)
    end
end
