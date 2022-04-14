# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
     end
end
    


target 'ToyExchange' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ToyExchange

  target 'ToyExchangeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ToyExchangeUITests' do
    # Pods for testing
  end

pod 'AlamofireImage', '~> 4.1'
pod 'MessageKit'
pod 'SwiftyJSON'
pod 'AppCenter'

end
