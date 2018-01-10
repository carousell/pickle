Pod::Spec.new do |s|
  s.name             = 'Pickle'
  s.version          = '1.3.0'
  s.summary          = 'Carousell flavoured image picker with multiple photo selections.'
  s.homepage         = 'https://github.com/carousell/pickle'
  s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.authors          = { 'bcylin' => 'bcylin@gmail.com',
                         'Suganth' => 'suganth@live.in' }
  s.source           = { :git => 'https://github.com/carousell/pickle.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thecarousell'

  s.ios.deployment_target = '9.0'
  s.ios.framework    = 'Photos'
  s.source_files     = 'Pickle/Classes/**/*'
  s.resources        = 'Pickle/Assets/**/*'
end
