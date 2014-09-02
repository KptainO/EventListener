Pod::Spec.new do |s|
  s.name                  = "EventListener"
  s.version               = "1.1.0"
  s.source                = { :git => "https://github.com/KptainO/EventListener.git", :tag => s.version.to_s }

  s.summary		  = "Event-Listener DOM API for iOS"
  s.homepage              = "https://github.com/KptainO/EventListener"
  s.license               = 'MIT'
  s.author                = 'KptainO'

  s.ios.deployment_target = '6.0'
  s.source_files          = 'Src/**/*.{h,m}'
  s.prefix_header_file    = 'Src/EventListener.h'
  s.private_header_files  = ['Src/EVEEvent+Friendly.h','EVEEventListener*.h', 'Src/EVEOrderedList.h']
  s.requires_arc          = true
end