# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bhamweather_session',
  :secret      => '5343421c98ef22be108a453b2741cb6466bca47442fc63b041b7070c1254887698734f9919ac142c6d6b079a9a70c641672356761a46d352d7be5c6e9cdfaae3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
