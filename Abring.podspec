Pod::Spec.new do |s|
s.name             = 'Abring'
s.version          = '0.2.0'
s.summary          = 'Abring SDK, pre release.'

s.description      = <<-DESC
Abring is an BaaS. In this version it will handle login with phone number. just type 2 lines of code and you're ready to go. for more information please visit our website.
DESC

s.homepage         = 'https://github.com/abring/sample_ios'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'hosein abbaspoor' => 'hosein@me.com' }
s.source           = { :git => 'https://github.com/abring/sample_ios.git', :tag => s.version.to_s }
s.dependency 'Alamofire'
s.dependency 'SwiftyJSON'
s.ios.deployment_target = '10.0'
s.source_files = 'Abring Demo/ABConfiguration.swift' , 'Abring Demo/ABExtentions.swift' , 'Abring Demo/ABLoginViewController.swift' , 'Abring Demo/ABManager.swift' , 'Abring Demo/ABPlayer.swift' , 'Abring Demo/AbringKit.bundle'

end
