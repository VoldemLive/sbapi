class ApplicationController < ActionController::API
  before_action :authenticate_user!, unless: :devise_controller?

  include ExceptionHandler
  include ActionController::Helpers

  SECRET_KEY = Rails.application.credentials.secret_key_base

  def encode_token(payload)
    puts "payload: #{payload}"
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    JWT.decode(token, SECRET_KEY)
  rescue JWT::DecodeError
    nil
  end

  def current_user
    return @current_user if defined?(@current_user)
    token = request.headers['Authorization']&.split(' ')&.last
    Rails.logger.debug "Token: #{token}"
    return nil unless token

    decoded_token = decode_token(token)
    Rails.logger.debug "Decoded token: #{decoded_token}"
    return nil unless decoded_token

    user_id = decoded_token[0]['id']
    @current_user = User.find_by(id: user_id)
    Rails.logger.debug "Current user: #{@current_user&.id}"
    @current_user
  end

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end

  private

  def json_request?
    request.format.json?
  end
end