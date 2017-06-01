

Pod::Spec.new do |s|


  s.name         = "LFBPageScrollView"
  s.version      = "1.0.0"
  s.summary      = "这是一个用于标题点击页面滚动的框架"
  s.homepage     = "https://github.com/LiuFuBo1991"
  s.license      = "MIT"
  s.author             = { "liufubo" => "18380438251@163.com" }
  s.social_media_url   = "http://www.jianshu.com/u/7d935e492eec"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LiuFuBo1991/LFBPageScrollView.git"}
  s.source_files  = "LFBPagingView/**/*"
  s.requires_arc = true
  s.dependency "Masonry", "~> 1.0.2"

end
