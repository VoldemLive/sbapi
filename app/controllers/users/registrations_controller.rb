class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]
  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed resource
  end

  def register_success
    token = encode_token(@user)
    render json: { message: 'Signed up sucessfully.', user: @user, token: token}, status: :created
  end

  def register_failed resource
    render json: { message: resource.errors.full_messages }, status: :bad_request
  end
end