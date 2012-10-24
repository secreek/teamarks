# Load / Save settings on local machine

require 'json'

module Settings
  attr_accessor :options = {}
  @filename = 'teamarks'
  def get_base_dir
    case `uname`
    when 'Darwin' then '/tmp' # DEBUG
    when 'Linux' then '/etc'
    end
  end
  
  def save()
    open(filename, 'w') {|f| JSON.dump(options, f)}
  end
  
  def load()
    options = open(filename) {|f| JSON.load(f)}
  end
  
end