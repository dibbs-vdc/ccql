CarrierWave.configure do |config|
  # NOTE: Not really ignoring these... 
  #       We just allowing the system to propogate the errors 
  #       without that ugly red screen of death
  config.ignore_integrity_errors = true
  config.ignore_processing_errors = true
  config.ignore_download_errors = true
end
