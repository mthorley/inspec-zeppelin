require 'nokogiri'

# Custom resource based on the InSpec resource DSL
class ZeppelinSiteConfig < Inspec.resource(1)
  name 'zeppelin_site_config'

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
    @path = '/home/matt/zeppelin/zeppelin-0.7.3-bin-all/conf/zeppelin-site.xml.template'
    @file = inspec.file(@path)

    unless @file.file?
      raise Inspec::Exceptions::ResourceSkipped, "Can't find file `#{@path}`"
    end

    # Protect from invalid XML content
    begin
      @props = {}
      doc = Nokogiri::XML(File.open(@path))
      # Capture all property keys and values 
      doc.xpath("/configuration/property").each do |p| 
          ns = p.elements
	  @props[ns.at('name').text] = ns.at('value').text
      end

    rescue StandardError => e
      raise Inspec::Exceptions::ResourceSkipped, "#{@file}: #{e.message}"
    end
  end

  def interpreters
    @props['zeppelin.interpreters']
  end

  def ssl_enabled
    @props['zeppelin.ssl']=='true' ? true : false
  end

  def xframe_options
    @props['zeppelin.server.xframe.options']
  end

  def xss_protection
    @props['zeppelin.server.xxss.protection']=='1' ? true : false
  end

  def websocket_origin
    @props['zeppelin.server.allowed.origins']
  end

  def anonymous_authentication
    @props['zeppelin.anonymous.allowed']=='true' ? true : false
  end

  # extracts value from "max-age=12345678"
  def enforce_https
    s = @props['zeppelin.server.strict.transport']
    max_age = /(\d.*)/.match(s)
    max_age[1].to_i > 3600 ? true : false
  end

  # Returns true or false from the 'File.exist?' method
  def exists?
    File.exist?(@path)
  end

end
