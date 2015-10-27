#
# Be sure to run `pod lib lint SlidingTutorial.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SlidingTutorial"
  s.version          = "0.9.0"
  s.summary          = "Simple library that helps developers to create awesome sliding iOS app tutorial."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "Applied parallax effects will make your product presentation look like Google apps tutorial."

  s.homepage         = "https://github.com/Cleveroad/slidingtutorial-ios"
  s.screenshots     = "http://cs629210.vk.me/v629210635/1b795/QXDdPlHqxZA.jpg", "http://cs629210.vk.me/v629210635/1b79e/fPDUzNVi_UI.jpg", "http://cs629210.vk.me/v629210635/1b7a7/f2MGj6e1cXI.jpg"
  s.license          = 'MIT'
  s.author           = { "Cleveroad" => "info@cleveroad.com" }
  s.source           = { :git => "https://github.com/Cleveroad/slidingtutorial-ios.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/CleveroadInc'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SlidingTutorial' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
