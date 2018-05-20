require 'iniparse'

# Custom resource based on the InSpec resource DSL
class ZeppelinShiroConfig < Inspec.resource(1)
  name 'zeppelin_shiro_config'

  supports platform: 'unix'

  desc "
    Zeppelin shiro.ini config that controls authentication and
    authorisation.
  "

  example "
    describe zeppelin_shiro_config do
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

  # Return true if pam realm is configured. #commented realm returns false
  def pam_authentication_enabled
    main = @shiro['main']
    main.select{ 
	|r| r.value=='org.apache.zeppelin.realm.PamRealm'
    }.count > 0 ? true : false
  end

  # defined by the number of Realms configured
  def authentication_methods_count
    main = @shiro['main']
    main.find { 
        |r| /Realm/ =~ r
    }.count
  end

  # Returns true or false from the 'File.exist?' method
  def exists?
    File.exist?(@path)
  end

end
