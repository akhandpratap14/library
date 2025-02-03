class ApiController < ActionController::API
    before_action :authorize_request
    attr_reader :current_user
  
    def render_error_response(error, status = :unauthorized)
      render json: { error: error.message }, status: status
    end
  
    def authorize_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        @decoded = JsonWebToken.decode(header)
        @current_user = User.find(@decoded[:user_id])
      rescue JWT::DecodeError => e
        render_error_response(e, :unauthorized)
      rescue ActiveRecord::RecordNotFound => e
        render_error_response(e, :unauthorized)
      end
    end
  end