# Allows the creation and management of schedules through HTTP
class SchedulesController < ApplicationAuthenticatedController
  before_action :set_schedule_by_week, only: %i[index]
  before_action :set_schedule, only: %i[show]

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

  protected

  def set_schedule_by_week
    @schedule = Schedule.find_by(week: params[:week], year: params[:year])
  end

  def set_schedule
    @schedule = Schedule.find_by_id(params[:id])
  end
end
