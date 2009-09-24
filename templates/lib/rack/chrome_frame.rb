module Rack
  class ChromeFrame

    def initialize(app, options={})
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      if env['HTTP_USER_AGENT'] =~ /MSIE/ && response.content_type == 'text/html'
        new_body = insert_goods(build_response_body(response)) 
        new_headers = recalculate_body_length(headers, new_body)
        [status, new_headers, new_body]
      else
        [status, headers, response]
      end
    end
    
    def build_response_body(response)
      response_body = ""
      response.each { |part| response_body += part }
      response_body
    end
    
    def recalculate_body_length(headers, body)
      new_headers = headers
      new_headers["Content-Length"] = body.length.to_s
      new_headers
    end

    def insert_goods(body)
      head = <<-HEAD
      <meta http-equiv="X-UA-Compatible" content="chrome=1">
      HEAD
      
      bod = <<-BOD
      <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/chrome-frame/1/CFInstall.min.js"></script>
      <div id="cf-placeholder"></div>
      <script>CFInstall.check({node: "cf-placeholder"});</script>
      BOD

      body.gsub!(/<\/head>/, head + "\n</head>")
      body.gsub!(/<\/body>/, bod  + "\n</body>")
      body
    end

  end
end