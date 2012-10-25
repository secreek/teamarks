# Load / Save settings on local machine

require 'json'

# WARNING every class that includes this module should
#         call super explicitly in initialize
module Settings
  attr_accessor :config

  def initialize
    parse_config
    load
  end

  def save()
    open(json_path, 'w') {|f| JSON.dump(@options, f)}
  end

  def load()
    path = json_path
    path = filename unless FileTest::exists?(path)
    @options = open(path) {|f| JSON.load(f)}
  end

  def parse_config
    @config ||= JSON.load(open("config/config.json"))
  end

  def filename
    @config['api_config_file_name']
  end

  def options
    # set default value of hash items to ''
    @options ||= Hash.new('')
  end

  def base_dir
    @env ||= `uname`.strip
    @config['base_dir'][@env]
  end

  def json_path
    "%s/%s" % [base_dir, filename]
  end

end
