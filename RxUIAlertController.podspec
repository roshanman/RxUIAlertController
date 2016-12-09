Pod::Spec.new do |s|
  s.name             = "RxUIAlertController"
  s.version          = "1.0.0"
  s.summary          = "ReactiveX way to use UIAlertController on iOS."
  s.description      = <<-EOS
  RxSwift binding for [Permission](https://github.com/delba/Permission) API that helps you with UIAlertController in iOS.
  EOS
  s.homepage         = "https://github.com/roshanman/RxUIAlertController"
  s.license          = 'MIT'
  s.author           = { "roshanman" => "morenotepad@163.com" }
  s.source           = { :git => "https://github.com/roshanman/RxUIAlertController.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/*.swift'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
end
