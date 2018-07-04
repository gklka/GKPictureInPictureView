#
# Be sure to run `pod lib lint GKPictureInPictureView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GKPictureInPictureView'
  s.version          = '0.1.0'
  s.summary          = 'FaceTime/iOS PiP like throwable view'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
FaceTime/iOS PiP like throwable view
                       DESC

  s.homepage         = 'https://github.com/gklka/GKPictureInPictureView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gklka' => 'gk@lka.hu' }
  s.source           = { :git => 'https://github.com/gklka/GKPictureInPictureView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gklka'

  s.ios.deployment_target = '10.0'

  s.source_files = 'GKPictureInPictureView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GKPictureInPictureView' => ['GKPictureInPictureView/Assets/*.png']
  # }

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
