require "rack/bug"

ActionController::Dispatcher.middleware.use Rack::Bug,
  :secret_key => "787889yghvbnvmh8l0q9avitiaA/KUrY7DE52hD4yWY+8z1",
  :password   => "secret"

ActionController::Dispatcher.middleware.use Rack::ChromeFrame
