# ValidatorService
# validates the configuration of a service before letting it save to database
class ValidatorService
  # @param service [Schedule] The service to be validated
  # @description Performs all the necessary validations to make sure a service
  #   is valid
  def initialize(service)
    @days = [
      { start: service.mon_hour_start, end: service.mon_hour_end },
      { start: service.tue_hour_start, end: service.tue_hour_end },
      { start: service.wed_hour_start, end: service.wed_hour_end },
      { start: service.thu_hour_start, end: service.thu_hour_end },
      { start: service.fri_hour_start, end: service.fri_hour_end },
      { start: service.sat_hour_start, end: service.sat_hour_end },
      { start: service.sun_hour_start, end: service.sun_hour_end }
    ]
  end

  # @param service [Schedule] The service to be validated
  # @return [Boolean] True if the service is valid. False otherwise
  # @description Checks that both start/end hour of a shift are either set or not
  #   set. Also checks that the end hour is greater of equal to the start hour
  def validate_service
    @days.each do |day|
      return false if limits_invalid? day
      return false if limits_inconsistent? day
      return false if limits_out_of_bounds? day
    end

    true
  end

  protected

  # @param day [Hash] Hash containing 2 values the start and end of a service on each day
  # @return [Boolean] True if the limtis are invalid, false otherwise
  # @description Checks the validity of the limits. For the limits to be valid, both have
  #   to be set, or not set at the same time
  def limits_invalid?(day)
    return true if (day[:start].is_a? Integer) && (!day[:end].is_a? Integer)
    return true if (!day[:start].is_a? Integer) && (day[:end].is_a? Integer)

    false
  end

  # @param day [Hash] Hash containing 2 values the start and end of a service on each day
  # @return [Boolean] True if the limtis are inconsistent, false otherwise
  # @description Checks the consistency of the limits. For the limits to be consisten,
  #   the upper limit has to be greater than the lower limit
  def limits_inconsistent?(day)
    return false unless day[:start]
    return true if day[:end] <= day[:start]

    false
  end

  # @param day [Hash] Hash containing 2 values the start and end of a service on each day
  # @return [Boolean] True if the limtis are out of bounds, false otherwise
  # @description Checks if the limtis are out of bounds. A limit is out of bounds when it's
  #   either grater than 23 or lower than 0
  def limits_out_of_bounds?(day)
    return false unless day[:start]
    return true if day[:start] >= 24 || day[:start].negative?
    return true if day[:end] >= 24 || day[:end].negative?

    false
  end
end
