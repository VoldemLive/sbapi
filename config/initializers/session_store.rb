Rails.application.config.session_store :cookie_store, 
  key: 'somniaaap', 
  expire_after: 24.hours, # Set session expiration
  secure: Rails.env.production?, # Use secure cookies in production
  domain: :all # Allow cookies across subdomains (if needed)