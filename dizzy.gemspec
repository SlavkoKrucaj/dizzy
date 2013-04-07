$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

include_files = ["Readme.md", "Gemfile", "Gemfile.lock", "{bin,lib,files}/**/*"].map do |glob|
  Dir[glob]
end.flatten

Gem::Specification.new do |s|
  s.name    = 'dizzy'
  s.version = '0.0.1'

  s.summary = "iOS resources made easy"
  s.description = "Middle layer between designers and developers"

  s.authors  = ['Slavko Krucaj']
  s.email    = ['slavko.krucaj@gmail.com']
  s.homepage = 'http://github.com/SlavkoKrucaj/dizzy'
  s.platform = Gem::Platform::RUBY

  s.executables = 'dizzy'

  s.add_dependency "thor", "~> 0.14.6"

  s.has_rdoc = true
  s.rdoc_options = ['--main', 'Readme.md']
  s.rdoc_options << '--inline-source' << '--charset=UTF-8'
  s.extra_rdoc_files = ['Readme.md']

  s.require_paths = ["lib"]
  s.files = include_files
end