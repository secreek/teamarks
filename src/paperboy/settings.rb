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
    case `uname`.strip
      when 'Darwin' then '/tmp'
      when 'Linux' then '/etc'
    end

    # For test, the temarks.json lives in current folder
    '.'
  end

  def save()
    open(filename, 'w') {|f| JSON.dump(@options, f)}
  end

  def load()
    @options = open(get_base_dir + '/' + filename) {|f| JSON.load(f)}
  end

  def initialize
    load
  end
end
