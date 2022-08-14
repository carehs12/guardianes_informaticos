class Schedule
  # Manages availabilities for each schedule
  class AvailabilitiesController < ApplicationAuthenticatedController
    before_action :set_schedule, only: %i[index]

    def index
      respond_to do |format|
        format.json do
          return respond_http_not_found unless @schedule

          respond_http_ok(Schedule::Availability.index(@schedule))
        end
      end
    end

    protected

    def set_schedule
      @schedule = Schedule.find_by_id(params[:schedule_id])
    end
  end
end
