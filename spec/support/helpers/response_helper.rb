module ResponseHelper
  def parsed_json_response
    response_data = response.body.blank? ? '{}' : response.body
    JSON.parse(response_data)
  end

  def expect_http_ok
    expect(response).to have_http_status(:success)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    parsed_json_response
  end

  def expect_http_bad_request
    expect(response.status).to eq(400)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    parsed_json_response
  end

  def expect_http_not_found
    expect(response.status).to eq(404)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    parsed_json_response
  end
end
