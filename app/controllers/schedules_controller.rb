# Allows the creation and management of schedules through HTTP
class SchedulesController < ApplicationAuthenticatedController
  before_action :set_schedule_by_week, only: %i[index]
  before_action :set_schedule, only: %i[show destroy]

  def index
    respond_to do |format|
      format.json do
        return respond_http_not_found unless @schedule

        respond_http_ok(@schedule.show)
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        return respond_http_not_found unless @schedule

        respond_http_ok(@schedule.show)
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        if schedule_date_available?(schedule_params)
          schedule = Schedule.create(schedule_params)
          return respond_http_ok(schedule.show) if schedule.persisted?

          respond_http_bad_request(schedule.errors.full_messages.to_sentence)
        end
      end
    end
  end

  def destroy
    return respond_http_not_found unless @schedule

    if @schedule.destroy
      respond_http_ok
    else
      respond_http_bad_request(@schedule.errors.full_messages.to_sentence)
    end
  end

  protected

  def schedule_date_available?(schedule_params)
    error_message = I18n.t('activerecord.errors.models.schedule.attributes.base.schedule_time_taken')
    if Schedule.find_by(week: schedule_params[:week], year: schedule_params[:year])
      respond_http_bad_request(error_message)
      false
    else
      true
    end
  end

  def set_schedule_by_week
    @schedule = Schedule.find_by(week: params[:week], year: params[:year])
  end

  def set_schedule
    @schedule = Schedule.find_by_id(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(
      :service_id,
      :week,
      :year
    )
  end
end
