class Resource

  attr_accessor :h_addition, :m_addition

  def generate()
    self.h_addition = ''
    self.m_addition = ''

    Dir.glob('**/*.*').reject { |f| /Resources.[h|m]/.match(f) }.map do |f|
      file = f.split('/').last.split('.')
      file_name = camel_case('res_' + file[0])
      file_path = file[1]
      gen_h_file(file_name, file_path)
      gen_m_file(file_name, file_path, f.split('/').last)
    end

    header_file = ERB.new(File.read('../classes/Resources.h')).result(binding)
    File.open('../classes/Resources.h', "w+") { |file| file.write(header_file) }

    m_file = ERB.new(File.read('../classes/Resources.m')).result(binding)
    File.open('../classes/Resources.m', "w+") { |file| file.write(m_file) }
  end

  def gen_h_file(file_name, file_path)
    self.h_addition += "+ (#{(file_path == 'png')? "UIImage":"NSString"} *)#{file_name};\n"
  end

  def gen_m_file(file_name, file_path, original_file)

    if (file_path == 'png')
      definition = "+ (UIImage *)#{file_name} {\n"
      definition += "\treturn [UIImage imageNamed:@\"#{original_file}\"];\n}\n"
    else
      definition = "+ (NSString *)#{file_name} {\n"
      definition += "\treturn @\"#{original_file}\";\n}\n"
    end
    self.m_addition += definition
  end

  def camel_case(file_name)
    file_name.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
  end
end