Pod::Spec.new do |s|
  s.name                  = "DeflateSwift"
  s.version               = "0.0.4"
  s.summary               = "Simple interface for the deflate compression format in Swift."
  s.homepage              = "https://github.com/tidwall/DeflateSwift"
  s.license               = { :type => "Attribution License", :file => "LICENSE" }
  s.source                = { :git => "https://github.com/tidwall/DeflateSwift.git", :tag => "#{s.version}" }
  s.authors               = { 'Josh Baker' => 'joshbaker77@gmail.com' }
  s.social_media_url      = "https://twitter.com/tidwall"
  s.ios.platform          = :ios, '8.0'
  s.ios.deployment_target = "8.0"
  s.osx.platform          = :osx, '10.9'
  s.osx.deployment_target = "10.9"
  s.source_files          = "deflate.swift"
  s.requires_arc          = true
  s.libraries             = 'z'
end
