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
        service = Service.create(create_service_params)
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

    if @service.update(update_service_params)
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

  def create_service_params
    params.fetch(:service, {}).permit(
      :name,
      :mon_hour_start, :mon_hour_end,
      :tue_hour_start, :tue_hour_end,
      :wed_hour_start, :wed_hour_end,
      :thu_hour_start, :thu_hour_end,
      :fri_hour_start, :fri_hour_end,
      :sat_hour_start, :sat_hour_end,
      :sun_hour_start, :sun_hour_end
    )
  end

  def update_service_params
    params.fetch(:service, {}).permit(
      :name
    )
  end

  def set_service
    @service = Service.find_by_id(params[:id])
  end
end
