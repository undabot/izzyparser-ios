platform :ios, '14.0'

target 'IzzyParser' do
 
  use_frameworks!
  inhibit_all_warnings!

  target 'IzzyParserTests' do
    inherit! :search_paths

    pod "Quick"
    pod "Nimble"
  end
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
  end
 end
end
