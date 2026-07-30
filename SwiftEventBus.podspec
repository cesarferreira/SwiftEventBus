Pod::Spec.new do |s|
  s.name = 'SwiftEventBus'
  s.version = '5.2.0'
  s.license = 'MIT'
  s.summary = 'Publish/subscribe event bus for iOS and macOS'
  s.homepage = 'https://github.com/cesarferreira/SwiftEventBus'
  s.social_media_url = 'http://twitter.com/cesarmcferreira'
  s.authors = { 'César Ferreira' => 'cesar.manuel.ferreira@gmail.com' }
  s.source = { :git => 'https://github.com/cesarferreira/SwiftEventBus.git', :tag => s.version }
  s.swift_version = '5.0'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.15'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '6.0'
  s.source_files = 'SwiftEventBus/SwiftEventBus.swift'
  s.requires_arc = true
end
