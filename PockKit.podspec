#
# Be sure to run `pod lib lint PockKit.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'PockKit'
  s.version          = '0.3.0'
  s.summary          = 'Core framework for building Pock widgets'

  s.description      = <<-DESC
PockKit is the core framework for building Pock widgets.
Documentation will be available soon on https://pock.app/docs/
                       DESC

  s.homepage         = 'https://pock.app/docs'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pierluigi Galdi' => 'pigi.galdi@gmail.com' }
  s.source           = { :git => 'https://github.com/pock/pockkit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pigigaldi'

  s.platform = :osx
  s.osx.deployment_target = '10.15'
  s.swift_version = '5'

  s.framework = 'Foundation'
  s.framework = 'AppKit'

  s.dependency 'TinyConstraints'

  s.exclude_files = ['docs/**/*']

  s.subspec '3rd' do |ss|
    ss.source_files = 'PockKit/3rd/**/*'
  end

  s.subspec 'Sources' do |ss|
    ss.dependency 'PockKit/3rd'
    ss.source_files = 'PockKit/Sources/**/*'
  end

end
