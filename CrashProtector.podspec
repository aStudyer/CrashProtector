Pod::Spec.new do |s|
  s.name         = "CrashProtector"
  s.version      = "1.0.0"
  s.ios.deployment_target = '8.0'
  s.summary      = "A convenient framework to prevent common crashes"
  s.homepage     = "https://github.com/aStudyer/CrashProtector"
  s.license      = "MIT"
  s.author             = { "aStudyer" => "astudyer@163.com" }
  s.social_media_url   = "https://blog.astudyer.com/"
  s.source       = { :git => "https://github.com/aStudyer/CrashProtector.git", :tag => s.version }
  s.source_files  = "CrashProtector"
  s.requires_arc = true
end
