# Allows the creation and management of services through HTTP
class ServicesController < ApplicationAuthenticatedController
  before_action :set_service, only: %i[update destroy]

  def index
    respond_to do |format|
      format.json do
        set_query_params # Defined in application_controller
        services = Service.index(@page, @per_page, @query)

        respond_http_ok(services)
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        service = Service.create(service_params)
        if service.persisted?
          respond_http_ok(service.show)
        else
          respond_http_bad_request(service.errors.full_messages.to_sentence)
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        set_service
        return respond_http_not_found unless @service

        respond_http_ok(@service.show)
      end
    end
  end

  def update
    return respond_http_not_found unless @service

    if @service.update(service_params)
      respond_http_ok(@service.show)
    else
      respond_http_bad_request(@service.errors.full_messages.to_sentence)
    end
  end

  def destroy
    return respond_http_not_found unless @service

    if @service.destroy
      respond_http_ok
    else
      respond_http_bad_request(@service.errors.full_messages.to_sentence)
    end
  end

  private

  def service_params
    params.fetch(:service, {}).permit(
      :name
    )
  end

  def set_service
    @service = Service.find_by_id(params[:id])
  end
end
