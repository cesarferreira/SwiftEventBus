Pod::Spec.new do |s|
  s.name = 'SwiftEventBus'
  s.version = '2.0.2'
  s.license = 'MIT'
  s.summary = 'Publish/subscribe event bus optimized for iOS'
  s.homepage = 'https://github.com/cesarferreira/SwiftEventBus'
  s.social_media_url = 'http://twitter.com/cesarmcferreira'
  s.authors = { 'César Ferreira' => 'cesar.manuel.ferreira@gmail.com' }
  s.source = { :git => 'https://github.com/cesarferreira/SwiftEventBus.git', :tag => s.version }
  s.ios.deployment_target = '9.0'
  s.source_files = 'SwiftEventBus/SwiftEventBus.swift'
  s.requires_arc = true
end
