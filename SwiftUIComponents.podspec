Pod::Spec.new do |s|
  s.name             = 'SwiftUIComponents'
  s.version          = '1.0.0'
  s.summary          = 'Reusable SwiftUI components collection for rapid development.'
  s.description      = 'SwiftUIComponents provides reusable UI components for SwiftUI including buttons, cards, lists, and more.'
  s.homepage         = 'https://github.com/muhittincamdali/SwiftUI-Components'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/SwiftUI-Components.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.9', '5.10', '6.0']
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation', 'SwiftUI'
end
