platform:ios,'11.0'
inhibit_all_warnings!
use_modular_headers!

def pods
  pod 'SnapKit'
  pod 'Alamofire'
  pod 'ObjectMapper'
  pod 'AlamofireObjectMapper'
  pod 'Ji'
  pod 'Kingfisher', '~> 4.10.0'
  pod 'KeychainSwift'
  pod 'KVOController'
  pod 'YYText'
  pod 'SVProgressHUD'
  pod 'MJRefresh', '~> 3.1.15.7'
  pod 'CXSwipeGestureRecognizer'

  pod 'Shimmer'
  pod 'FDFullscreenPopGesture'
  pod 'Moya/RxSwift'
  pod 'SwiftyJSON', '~> 4.3'
  pod 'DeviceKit'

end

target 'YuanCommunityV2ex' do
  pods
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'Ji' or target.name == 'Moya'  or target.name == 'Result'
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.2'
        end
      end
      if target.name == 'DrawerController'
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.0'
        end
      end
    end
  end
end
