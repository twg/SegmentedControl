
Pod::Spec.new do |s|
  s.name             = "SegmentedControl"
  s.version          = "0.1.0"
  s.summary          = "A segmented control wrapped in a UIView in Swift"

  s.description      = <<-DESC
                        SegmentedControl allows you to easily add a segmented control to your view controller.
                       DESC

  s.homepage         = "https://github.com/twg/SegmentedControl"
  s.license          = 'MIT'
  s.author           = { "The Working Group" => "mobile@twg.ca" }
  s.source           = { :git => "https://github.com/twg/SegmentedControl.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SegmentedControl' => ['Pod/Assets/*.png']
  }

end
