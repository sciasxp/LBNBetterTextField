#
# Be sure to run `pod lib lint LBNBetterTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LBNBetterTextField"
  s.version          = "0.0.4"
  s.summary          = "A UITextField replacement that adds block for delegate methods, field validation and formatting."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
A replacement for UITextField with the objective to make it ever so easier to to work with this class. First there is block functions that substitutes the default delegate methods, you can also define max and min length for field, set a validation block and a formatting block. Other nicities also included. Checkout documentation.
This project is based on UITextField+DelegationBlocks and UITextField-Shake projects. Both are available on GitHub and CocoaPods with MIT Licences.
                       DESC

  s.homepage         = "https://github.com/sciasxp/LBNBetterTextField"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Luciano Bastos Nunes" => "sciasxp@gmail.com" }
  s.source           = { :git => "https://github.com/sciasxp/LBNBetterTextField.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LBNBetterTextField' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
