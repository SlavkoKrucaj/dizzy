class Podspec

  attr_accessor :tag
  attr_accessor :git_url
  attr_accessor :pod_name

  def generate(tag, name)
    self.tag = tag

    git = `git config --get remote.dizzy.url`
    @git_url = (/^git@/.match(git))? "https://github.com/" + git.split(':')[1].strip():git.strip();

    @pod_name = name;

    header_file = ERB.new(File.read("#{name}.podspec")).result(binding)
    File.open("#{name}.podspec", "w+") { |file| file.write(header_file) }
  end

end