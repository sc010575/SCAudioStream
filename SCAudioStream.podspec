#
#  Be sure to run `pod spec lint SCAudioStream.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = 'SCAudioStream'
  s.version          = '0.1.2'
  s.summary          = 'Easy audio streaming for iOS'
  s.description      = <<-DESC
SCAudioStream is an audio player written in Swift, making it simpler to work with audio playback from streams and files.
DESC

  s.homepage         = 'https://github.com/sc010575/SCAudioStream'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Suman Chatterjee' => 'chatterjeesuman@gmail.com' }
  s.source           = { :path => '.' }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.source_files = 'SCAudioStream/Classes/**/*'
end
