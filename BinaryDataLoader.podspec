Pod::Spec.new do |s|
  s.name             = 'BinaryDataLoader'
  s.version          = '0.2.7'
  s.swift_version    = '5.0'
  s.summary          = 'Simple binary data loader for iOS'
 
  s.description      = <<-DESC
  Simple binary data loader for iOS. Simple binary data loader for iOS
                       DESC
 
  s.homepage         = 'https://github.com/egabor/BinaryDataLoader'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Máté Gujgiczer' => 'mate.gujgiczer@icloud.com' }
  s.source           = { :git => 'https://github.com/egabor/BinaryDataLoader.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '9.3'
  s.source_files = 'BinaryDataLoader/**/*.swift'
 
end
