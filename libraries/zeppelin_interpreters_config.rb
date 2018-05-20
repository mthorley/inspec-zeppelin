require 'iniparse'

# Custom resource based on the InSpec resource DSL
class ZeppelinSiteXmlConfig < Inspec.resource(1)
  name 'zeppelin_interpreters_config'

  supports platform: 'unix'

  desc "
    Zeppelin interpreters config that list which interpreters can be used.
  "

  example "
    describe zeppelin_interpreters config do
    end
  "

  # Load the configuration file on initialization
  def initialize
    @path = '/home/matt/zeppelin/zeppelin-0.7.3-bin-all/conf/shiro.ini'
    @file = inspec.file(@path)

    unless @file.file?
      raise Inspec::Exceptions::ResourceSkipped, "Can't find file `#{@path}`"
    end

    # Protect from invalid INI content
    begin
      @shiro = IniParse.parse(@file.content)

    rescue StandardError => e
      raise Inspec::Exceptions::ResourceSkipped, "#{@file}: #{e.message}"
    end
  end

  # Returns true or false from the 'File.exist?' method
  def exists?
    File.exist?(@path)
  end

end
