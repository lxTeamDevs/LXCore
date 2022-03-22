Pod::Spec.new do |s|
  s.name             = 'LXCore'
  s.version          = '0.1.0'
  s.summary          = 'Some description'
  s.swift_versions   = '5.0' 
 
  s.description      = 'Detailed description'
  
  s.framework        = "UIKit"
  s.dependency "Moya/RxSwift", "~> 14.0.0"
  s.dependency "RxOptional"
  s.dependency "RxDataSources", "~> 4.0.1"


  s.homepage         = 'https://github.com/lxTeamDevs/LXCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LXTeamDevs' => 'lxteamdevs@gmail.com' }
  s.source           = { :git => 'https://github.com/lxTeamDevs/LXCore.git', :tag => "#{s.version}" }
 
  s.ios.deployment_target = '13.0'
  s.source_files = 'LXCore/**/*.{swift,h}'
 
end
