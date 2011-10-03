class OpenAir
  
  def format_request(data)
    %{<request API_version="1.0" client="test app" client_ver="1.1" namespace="default" key="0123456789">
      #{data}
    </request>}
  end
  
  def request
    
  end
  
  def get_time
    request format_request("<Time/>")
  end
  
end