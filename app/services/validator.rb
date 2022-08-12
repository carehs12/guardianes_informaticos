# ValidatorService
# validates the configuration of a schedule before letting it save to database
class OptimizerService
  # @param schedule [Schedule] The schedule to be validated
  # @description Performs all the necessary validations to make sure a schedule
  #   is valid
  def initialize(schedule)
    @days = [
      { start: schedule.mon_hour_start, end: schedule.mon_hour_end },
      { start: schedule.tue_hour_start, end: schedule.tue_hour_end },
      { start: schedule.wed_hour_start, end: schedule.wed_hour_end },
      { start: schedule.thu_hour_start, end: schedule.thu_hour_end },
      { start: schedule.fri_hour_start, end: schedule.fri_hour_end },
      { start: schedule.sat_hour_start, end: schedule.sat_hour_end },
      { start: schedule.sun_hour_start, end: schedule.sun_hour_end }
    ]
  end

  # @param schedule [Schedule] The schedule to be validated
  # @return [Boolean] True if the schedule is valid. False otherwise
  # @description Checks that both start/end hour of a shift are either set or not
  #   set. Also checks that the end hour is greater of equal to the start hour
  def validate
    @days.each do |day|
      return false if limits_invalid? day
      return false if limits_inconsistent? day
      return false if limits_out_of_bounds? day
    end

    true
  end

  protected

  # @param day [Hash] Hash containing 2 values the start and end of a schedule on each day
  # @return [Boolean] True if the limtis are invalid, false otherwise
  # @description Checks the validity of the limits. For the limits to be valid, both have
  #   to be set, or not set at the same time
  def limits_invalid?(day)
    return false if (day[:start].is_a? Integer) && (!day[:end].is_a? Integer)
    return false if (!day[:start].is_a? Integer) && (day[:end].is_a? Integer)
  end

  # @param day [Hash] Hash containing 2 values the start and end of a schedule on each day
  # @return [Boolean] True if the limtis are inconsistent, false otherwise
  # @description Checks the consistency of the limits. For the limits to be consisten,
  #   the upper limit has to be greater than the lower limit
  def limits_inconsistent?(day)
    return false if day[:end] <= day[:start]
  end

  # @param day [Hash] Hash containing 2 values the start and end of a schedule on each day
  # @return [Boolean] True if the limtis are out of bounds, false otherwise
  # @description Checks if the limtis are out of bounds. A limit is out of bounds when it's
  #   either grater than 23 or lower than 0
  def limits_out_of_bounds?(day)
    return false if day[:start] >= 24 || day[:start].negative?
    return false if day[:end] >= 24 || day[:end].negative?
  end
end
