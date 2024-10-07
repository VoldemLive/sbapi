class Users::SessionsController < Devise::SessionsController
  require 'jwt'
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create, :destroy]

  def destroy 
    @logged_in_user = current_user
    sign_out @logged_in_user
    render json: { message: "You are logged out." }, status: :ok
  end

  private

  def respond_with(resource, _opts = {})
    if !resource.id.nil?
      token = encode_token(resource.as_json)
      render json: { 
        message: 'You are logged in.', 
        user: resource, 
        token: token 
      }, status: :created
    else
      render json: { message: 'Authentication failed.'}, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    log_out_success && return if @logged_in_user
    log_out_failure
  end

  def log_out_success
    render json: { message: "You are logged out." }, status: :ok
  end

  def log_out_failure
    render json: { message: "Hmm nothing happened."}, status: :unauthorized
  end


end