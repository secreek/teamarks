class Response
  attr_accessor :status, :message

  def initialize(status, message)
    @status = status
    if message.class.method_defined? :to_json_obj
      @message = message.to_json_obj
    else
      @message = message
    end
  end

  def to_json
    {
      'status' => @status,
      'message' => @message
    }.to_json
  end
end
