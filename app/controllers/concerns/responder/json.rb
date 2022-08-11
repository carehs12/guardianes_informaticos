# Responder::Json. Contains all methods used to respond a JSON request
module Responder  
  module Json
    # JSON successful response
    def respond_http_ok(data = nil)
      response_body[:data] = data
      render status: 200, json: response_body.to_json
    end

    # JSON server error response
    def respond_http_server_error(message = '')
      render status: 500, json: {
        error: { message: message }
      }.to_json
    end

    # JSON bad request response
    def respond_http_bad_request(message = '')
      render status: 400, json: {
        error: { message: message }
      }.to_json
    end

    # JSON not found response
    def respond_http_not_found(message = '')
      render status: 404, json: {
        error: { message: message }
      }.to_json
    end
  end
end
