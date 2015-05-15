#
# Be sure to run `pod lib lint LinearLayoutForIOS.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LinearLayoutForIOS"
  s.version          = "0.1.0"
  s.summary          = "A horizontal and vertical linear layout to which you can add members at positions, set their sizes, and remove them."
  s.description      = <<-DESC
                       The layouts manage their members using auto layout constraints automatically. Don't give the members that you insert
                        into the layout any other constraints, they would not work.
                       DESC
  s.homepage         = "https://bitbucket.org/dplisek/linearlayoutforios"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Dominik Plíšek" => "dominik.plisek@plech.org" }
  s.source           = { :git => "https://bitbucket.org/dplisek/linearlayoutforios.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LinearLayoutForIOS' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
