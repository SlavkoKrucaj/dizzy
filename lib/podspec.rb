class Podspec

  attr_accessor :tag
  attr_accessor :git_url

  def generate(tag)
    self.tag = tag

    git = `git config --get remote.dizzy.url`
    @git_url = (/^git@/.match(git))? "https://github.com/" + git.split(':')[1].strip():git.strip();

    header_file = ERB.new(File.read('Resources.podspec')).result(binding)
    File.open('Resources.podspec', "w+") { |file| file.write(header_file) }
  end

end