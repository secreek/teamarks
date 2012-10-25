# Load / Save settings on local machine
require 'json'

# WARNING every class that includes this module should
#         call super explicitly in initialize
module Settings
  def initialize
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

  private
    def filename
      "teamarks.json"
    end

    def base_dir
      "/etc/teamarks"
    end

    def options
      # set default value of hash items to ''
      @options ||= Hash.new('')
    end

    def json_path
      "%s/%s" % [base_dir, filename]
    end

end
