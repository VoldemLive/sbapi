module AuthenticationCheck
  extend ActiveSupport::Concern
  
  def is_user_logged_in
    unless current_user
      render json: { message: "No user is authenticated." }, status: :unauthorized
    end
  end
end