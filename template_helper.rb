module Rails
  class TemplateRunner

    def gh_gem(name, options={})
      lib = name.split('-')[1]
      options.reverse_merge!(:lib => lib, :source => 'http://gems.github.com')
      gem(name, options)
    end
    
    def cutter_gem(name, options={})
      options.reverse_merge!(:source => 'http://gemcutter.org')
      gem(name, options)
    end

    def copy_files_from_template(template_path)
      puts "Copying awesome template files to application"
      Dir.glob("#{template_path}/templates/**/*").each do |file_path|
        next unless File.file?(file_path)
        rails_path = file_path.gsub(/.*?templates\//, '')
        file(rails_path, File.read(file_path))
      end
    end
  end
end
