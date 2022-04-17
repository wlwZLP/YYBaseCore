#
# Be sure to run `pod lib lint YYBaseCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YYBaseCore'
  s.version          = '0.1.0'
  s.summary          = 'A short description of YYBaseCore.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wlwZLP/YYBaseCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhulp' => '1060021533@qq.com' }
  s.source           = { :git => 'https://github.com/wlwZLP/YYBaseCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'

  s.source_files = 'YYBaseCore/Classes/**/*'
  
 
 
end
