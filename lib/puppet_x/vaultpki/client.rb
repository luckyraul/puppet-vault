# class
module PuppetX::Vaultpki
  # dsds
  class Client
    def hello
      'hello'
    end

    def create_cert(common_name, ttl, alt_names: nil, ip_sans: nil)
      api_path = '/v1' + @api_secret_engine + '/issue/' + @api_secret_role
      payload = {
        name: @api_secret_role,
        common_name: common_name,
        ttl: ttl,
      }

      # Check if any Subject Alternative Names were given
      # Check if any IP Subject Alternative Names were given
      payload[:alt_names] = alt_names.join(',') if alt_names
      payload[:ip_sans] = ip_sans.join(',') if ip_sans

      post(api_path, body: payload)
    end

    def post(path, body: nil, headers: @headers)
      url = "#{@api_url}#{path}"
      execute('post', url, body: body, headers: headers, redirect_limit: @redirect_limit)
    end

    def execute(method, url, body: nil, headers: {}, redirect_limit: @redirect_limit)
      raise ArgumentError, 'HTTP redirect too deep' if redirect_limit.zero?

      # setup our HTTP class
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      # http.verify_mode = @ssl_verify

      # create our request
      request = net_http_request_class(method).new(uri)
      # copy headers into the request
      headers.each { |k, v| request[k] = v }
      # set body on the request
      if body
        request.content_type = 'application/json'
        request.body = body.to_json
      end

      # execute
      resp = http.request(request)

      # check response for success, redirect or error
      case resp
      when Net::HTTPSuccess then
        body = resp.body
        if body
          JSON.parse(body)
        else
          resp
        end
      when Net::HTTPRedirection then
        execute(method, resp['location'],
                body: body, headers: headers,
                redirect_limit: redirect_limit - 1)
      else
        Puppet.debug("throwing HTTP error: request_method=#{method} request_url=#{url} request_body=#{body} response_http_code=#{resp.code} resp_message=#{resp.message} resp_body=#{resp.body}")
        stack_trace = caller.join("\n")
        Puppet.debug("Raising exception: #{resp.error_type.name}")
        Puppet.debug("stack trace: #{stack_trace}")
        message = 'code=' + resp.code
        message += ' message=' + resp.message
        message += ' body=' + resp.body
        raise resp.error_type.new(message, resp)
      end
    end
  end
end
