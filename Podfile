# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'EpubReader' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Alamofire', '5.7.0'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'SnapKit', '5.6.0'
  pod 'ScrollableSegmentedControl', '1.5.0'
  pod 'Kingfisher', '7.6.2'
  pod 'SDWebImage'
  pod 'Connectivity'
  pod 'Whisper'
  pod 'SwiftyJSON', '4.0'
  pod 'GoogleSignIn', '7.0.0'
  pod 'FBSDKCoreKit', '15.1'
  pod 'FBSDKLoginKit', '15.1'
  pod 'VisualEffectView', '4.1.3'
  pod 'FolioReaderKit', path: '../'

  # Pods for EpubReader

  target 'EpubReaderTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '6.5.0'
    pod 'RxTest', '6.5.0'
  end

  target 'EpubReaderUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
      installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                 end
            end
     end
  end

end
