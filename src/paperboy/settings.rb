# Load / Save settings on local machine

require 'json'

module Settings
  def filename
    @filename = "teamarks.json"
  end

  def options
    # set default value to ''
    @options ||= Hash.new('')
  end

  def get_base_dir
    case `/usr/bin/uname`.strip
      when 'Darwin' then '/tmp'
      when 'Linux' then '/etc/teamarks'
    end
  end

  def get_json_path
    "%s/%s" % [get_base_dir, filename]
  end

  def save()
    open(get_json_path, 'w') {|f| JSON.dump(@options, f)}
  end

  def load()
    path = get_json_path
    path = filename unless FileTest::exists?(path)
    @options = open(path) {|f| JSON.load(f)}
  end

  def initialize
    load
  end
end
