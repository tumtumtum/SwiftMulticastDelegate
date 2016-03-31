Pod::Spec.new do |s|
  s.name         = "MulticastDelegate"
  s.version      = "0.1.0"
  s.summary      = "A safe and efficient implementation of multicast delegates for Swift"
  s.homepage     = "https://github.com/tumtumtum/MulticastDelegate/"
  s.license      = 'MIT'
  s.author       = { "Thong Nguyen" => "tumtumtum@gmail.com" }
  s.source       = { :git => "https://github.com/tumtumtum/MulticastDelegate.git", :tag => s.version.to_s}
  s.platform     = :ios
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.ios.frameworks   = 'CoreFoundation'
  s.osx.deployment_target = '10.7'
  s.osx.frameworks = 'CoreFoundation'
  s.watchos.deployment_target = '2.0'
  s.watchos.frameworks   = 'CoreFoundation'
  s.source_files = 'src/MulticastDelegate/**/*.swift'
end
