
Pod::Spec.new do |s|
  s.name             = "Socketing"
  s.version          = "1.0.0"
  s.summary          = "A minimal iOS/macOS Socket Framework."

  s.description      = <<-DESC
                        A minimal iOS/macOS Socket Framework in Swift.
                        DESC

  s.homepage         = "https://github.com/Meniny/Socketing"
  s.license          = 'MIT'
  s.author           = { "Meniny" => "Meniny@qq.com" }
  s.source           = { :git => "https://github.com/Meniny/Socketing.git", :tag => s.version.to_s }
  s.social_media_url = 'http://meniny.cn/'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

  s.source_files = 'Socketing/**/*{.swift}', 'Socketing/**/*{.h}', 'Socketing/**/*{.c}'
  s.public_header_files = 'Socketing/**/*{.h}'
  s.ios.frameworks = 'Foundation'
  s.osx.frameworks = 'Foundation'
end
