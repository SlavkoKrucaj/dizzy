require 'resource'
require 'podspec'

class Dizzy < Thor

  desc 'start','setups dizzy in current folder'
  method_option :repo, :required => true
  method_option :spec, :required => true
  method_option :name, :required => true
  def start

    config = {}
    config['name'] = options[:name]

    Dir.mkdir('.dizzy') if (!Dir.exist?('.dizzy'))
    File.open(".gitignore", 'a+') { |file| file.write '.dizzy' }
    File.open(".dizzy/.config", 'w+') { |file| file.write config.to_yaml }

    Dir.chdir '.dizzy' do
      if (!Dir.exist?('.git'))
        `git init`
      end
      if (`git remote`.split.include? 'dizzy')
        `git remote set-url dizzy #{options[:repo]}`
      else
        `git remote add dizzy #{options[:repo]}`
      end

      #don't do this if at home on slow internet
      FileUtils.rm_r(Dir.home + "/.cocoapods/dizzy") if (Dir.exist?(Dir.home + "/.cocoapods/dizzy"))
      system "pod repo add dizzy #{options[:spec]}"
    end
  end

  desc 'push', 'push new version of resources'
  method_option :message, :required => true
  method_option :tag, :required => true
  def push

    #clean up dizzy
    Dir.chdir('.dizzy') do
      `git pull dizzy master`
      Dir.glob('**/*/').reject { |f| /.git/.match(f) || /.dizzy/.match(f) }.each do |dir|
        FileUtils.rm_r(dir)
      end
      `git add -A .`
    end

    Dir.mkdir('.dizzy/resources')
    Dir.mkdir('.dizzy/classes')

    Dir.glob('**/*.*').each { |f| FileUtils.cp f, ".dizzy/resources/#{f}"}
    Dir.glob('**/*/').reject { |f| /.git/.match(f) || /.dizzy/.match(f) }.each do |dir|
      FileUtils.cp_r dir, ".dizzy/resources/#{dir}"
    end

    settings_file = File.read ".dizzy/.config"
    config = YAML::load(File.read(".dizzy/.config")) if (File.exist?(".dizzy/.config"))

    FileUtils.cp "#{ROOT}/files/Resources.h", '.dizzy/classes/Resources.h'
    FileUtils.cp "#{ROOT}/files/Resources.m", '.dizzy/classes/Resources.m'
    FileUtils.cp "#{ROOT}/files/Resources.podspec", ".dizzy/#{config["name"]}.podspec"

    Dir.chdir '.dizzy/resources' do
      Resource.new.generate
    end

    Dir.chdir '.dizzy' do
      Podspec.new.generate(options[:tag], config['name'])

      `git add -A .`
      `git commit -m #{options[:message]}`
      `git push dizzy master`

      `git tag -a #{options[:tag]} -m #{options[:message]}`
      `git push dizzy --tags`

      # inace treba pushat na dizzy-a sve
      system "pod push dizzy"
    end
    if (!`git config --get remote.origin.url`.empty?)
      `git tag -a #{options[:tag]} -m #{options[:message]}`
      `git push origin --tags`
    end
  end

  desc 'version', 'what is the latest version of resources'
  def version
    Dir.chdir('.dizzy') do
      `git tags`.last
    end
  end

  desc 'clean', 'remove dizzy from current directory'
  def clean
    FileUtils.rm_r('.dizzy')
  end
end