Pod::Spec.new do |s|

  s.name         = "WatchSessionManager"
  s.version      = "0.0.1"
  s.summary      = "A short description of WatchSessionManager."

  s.homepage     = "http://EXAMPLE/WatchSessionManager"

  s.license      = "Apache License, Version 2.0"

  s.author             = { "Carlos Aguiar" => "carlosaguiar96@gmail.com" }
  s.social_media_url   = "https://github.com/carlosaguiar"

  s.ios.deployment_target = "10.0"
  s.watchos.deployment_target = "2.0"

  s.source       = { :git => "https://github.com/carlosaguiar/WatchSessionManager", :tag => "#{s.version}" }
  s.source_files  = "Source/*.swift"

  s.ios.frameworks = 'Foundation', 'WatchConnectivity'
  s.watchos.frameworks = 'Foundation', 'WatchConnectivity'

  s.requires_arc = true

end
