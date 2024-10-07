Rails.application.config.session_store :cookie_store, 
  key: '_your_app_session', 
  expire_after: 30.minutes, # Set session expiration
  secure: Rails.env.production?, # Use secure cookies in production
  domain: :all # Allow cookies across subdomains (if needed)