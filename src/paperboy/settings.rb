# Load / Save settings on local machine
require 'json'
require 'singleton'

class Settings
  include Singleton

  attr_accessor :options

  def initialize
    # init members
    @options ||= Hash.new('')
    @filename = "teamarks.json"

    load
  end

  def save
    open(json_path, 'w') {|f| JSON.dump(@options, f)}
  end

  def load
    path = json_path
    path = @filename unless FileTest::exists?(path)
    @options = open(path) {|f| JSON.load(f)}
  end

  private
    def base_dir
      case `uname`.strip
        when 'Darwin' then "/tmp/teamarks"
        when 'Linux' then "/etc/teamarks"
      end
    end

    def json_path
      "%s/%s" % [base_dir, @filename]
    end
end
