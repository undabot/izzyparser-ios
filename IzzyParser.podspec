Pod::Spec.new do |s|
  s.name             = 'IzzyParser'
  s.version          = '0.2.1'
  s.summary          = 'Serializing and deserializing JSON:API resources.'

  s.homepage				 = 'https://gitlab.com/undabot/izzyparser'
  s.description      = 'IzzyParser is a library for serializing and deserializing JSON:API objects'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Undabot' => 'ios@undabot.com' }
  s.source           = { :git => 'git@gitlab.com:undabot/izzyparser.git', :branch => 'develop' }

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.1'

  s.source_files     = 'IzzyParser/**/*.swift'
end
