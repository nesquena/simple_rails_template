HoptoadNotifier.configure do |config|
  config.api_key = 'HOPTOAD-KEY'
  config.environment_filters << 'rack-bug.*'
end