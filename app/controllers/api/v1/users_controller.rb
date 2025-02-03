class Api::V1::UsersController < ApiController
    before_action :set_user, only: %i[show update destroy]
  
    def index
      users = User.all
      render json: { data: users.map { |user| user_response(user) } }, status: :ok
    end
  
    def show
      render json: { data: user_response(@user) }, status: :ok
    end
  
    def update
      if @user.update(user_params)
        render json: { message: 'User updated successfully' }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      if @user.destroy
        render json: { message: 'User deleted successfully' }, status: :ok
      else
        render json: { message: "Something went wrong" }, status: :unprocessable_entity
      end
    end
  
    private

    def user_response(user)
        user.as_json(except: [:password_digest, :created_at, :updated_at, :status])
    end
  
    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "User not found" }, status: :not_found
    end
  
    def user_params
      params.permit(:name, :username, :email, :password)
    end
  end
  