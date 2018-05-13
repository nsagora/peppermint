#
# Be sure to run `pod lib lint ValidationToolkit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ValidationToolkit'
  s.version          = '0.6.2'
  s.summary          = 'Lightweight framework for input validation written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Validation Toolkit is designed to be a lightweight framework specialised in user data validation, such as email format, input length or passwords matching, for Swift projects."

  s.homepage         = 'https://github.com/nsagora/validation-toolkit'
  s.license          = { :type => 'MIT License', :file => 'LICENSE' }
  s.author           = { 'Alex Cristea' => 'alex@thinslices.com' }
  s.source           = { :git => 'https://github.com/nsagora/validation-toolkit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nsagora'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/*/*.swift'
end
