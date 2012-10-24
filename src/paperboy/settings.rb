# Load / Save settings on local machine

require 'json'

module Settings
  @options
  @filename = 'teamarks.json'
  
  def get_base_dir
    case `uname`
    when 'Darwin' then '/tmp' # DEBUG
    when 'Linux' then '/etc'
    end
  end
  
  def save()
    open(get_base_dir + '/' + @filename, 'w') {|f| JSON.dump(@options, f)}
  end
  
  def load()
    @options = open(get_base_dir + '/' + @filename) {|f| JSON.load(f)}
  end
  
  def initialize
    load
  end
end