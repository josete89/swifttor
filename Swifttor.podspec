Pod::Spec.new do |s|
  s.name             = "Swifttor"
  s.version          = "1.0"
  s.summary          = "An akka implementation on Swift"
  s.description      = "Library to use the actor paradming on swift with differnt kind of actors"
  s.module_name      = "Swifttor"
  s.homepage         = "https://github.com/josete89/swifttor"
  s.license          = 'MIT'
  s.authors           = { "Jose Luis Alcala" => "josete_zgz_89@hotmail.com" }
  s.source           = { :git => 'https://github.com/josete89/swifttor.git', :tag => "#{s.version}" }
  s.social_media_url = 'https://twitter.com/joseluisalcala'
  s.source_files = 'Swifttor/*.swift'
  s.cocoapods_version = '>= 1.0'
  s.ios.deployment_target = '11.1'
  s.osx.deployment_target = '10.13'
  s.tvos.deployment_target = '11.1'
  s.watchos.deployment_target = '4.1'
  s.frameworks = 'Foundation'
end
