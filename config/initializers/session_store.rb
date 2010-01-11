# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vfac_session',
  :secret      => 'ac963c4b7abeefd690c129a4ee7f0cba040a0e925390c7eac66e1df38004f3679aa0b2d3e692a5061933c2a55aba909e1608d8cf7918d26063c3cc2e747ccc1d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
