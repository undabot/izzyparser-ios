Pod::Spec.new do |s|
  s.name             = 'IzzyParser'
  s.version          = '1.0.0'
  s.summary          = 'Serializing and deserializing JSON:API resources.'

  s.homepage				 = 'https://github.com/undabot/izzyparser-ios'
  s.description      = 'IzzyParser is a library for serializing and deserializing JSON:API objects'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Undabot' => 'ios@undabot.com' }
  s.source           = { :git => 'git@github.com:undabot/izzyparser-ios.git', :tag => '1.0.0' }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files     = 'IzzyParser/**/*.swift'
end
