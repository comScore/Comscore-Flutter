#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint comscore_analytics_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'comscore_analytics_flutter'
  s.version          = '0.0.1'
  s.summary          = 'iOS flutter plugin for Comscore Analytics'
  s.description      = <<-DESC
This library is used to collect analytics from iOS applications through the flutter plugin.
                       DESC
  s.homepage         = 'http://comscore.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'comscore.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.dependency 'ComScore', '6.14'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.resource_bundles = {'comscore_analytics_flutter_privacy' => ['Resources/PrivacyInfo.xcprivacy']}

end
