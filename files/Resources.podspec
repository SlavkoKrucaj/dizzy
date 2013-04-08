Pod::Spec.new do |s|
  s.name         = "<%= @pod_name %>"
  s.version      = "<%= @tag %>"
  s.summary      = "resources."
  s.description  = <<-DESC
                      * Dummy description which has to be bigger than summary :).
                   DESC
  s.homepage     = "www.dummy.com"

  s.license  = { :type => 'Custom', :text => 'Copyright (C) 2012 Slavko Krucaj. All Rights Reserved.' }

  s.author       = { "Slavko Krucaj" => "slavko@soundcloud.com" }
  s.source       = { :git => "<%= @git_url %>", :tag => "<%= @tag %>" }
  s.platform     = :ios, '5.0'
  s.source_files = 'classes/Resources.{h,m}'
  s.resource     = 'resources/**/*.*'
end
