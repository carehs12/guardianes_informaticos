class Schedule
  # Manages availabilities for each schedule
  class AvailabilitiesController < ApplicationAuthenticatedController
    before_action :set_schedule, only: %i[index update]

    def index
      respond_to do |format|
        format.json do
          return respond_http_not_found unless @schedule

          respond_http_ok(Schedule::Availability.index(@schedule))
        end
      end
    end

    def update
      respond_to do |format|
        format.json do
          puts "???????????????????????????????????????????"
          puts "???????????????????????????????????????????"
          return respond_http_not_found unless @schedule
          puts "???????????????????????????????????????????"
          puts "???????????????????????????????????????????"

          availabilities_attributes = availabilities_params
          puts "-----------------------"
          puts "-----------------------"
          puts availabilities_attributes.to_json
          puts "-----------------------"
          puts "-----------------------"
          return respond_http_ok(@schedule.optimize) if @schedule.update(availabilities_attributes)

          respond_http_bad_request(@schedule.errors.full_messages.to_sentence)
        end
      end
    end

    protected

    def set_schedule
      @schedule = Schedule.find_by_id(params[:schedule_id])
    end

    def availabilities_params
      params.require(:schedule).permit(
        availabilities_attributes: %i[
          id hour00 hour01 hour02 hour03 hour04 hour05
          hour07 hour08 hour09 hour10 hour04 hour11
          hour12 hour13 hour14 hour15 hour16 hour17
          hour18 hour19 hour20 hour21 hour22 hour23
        ]
      )
    end
  end
end
