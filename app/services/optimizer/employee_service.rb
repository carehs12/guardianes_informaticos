module Optimizer
  # Optimizer::EmployeeServices
  # Groups the availability of an employee, so it can always retrieve relevant data
  # like on which day can the person can work the most
  class EmployeeService
    attr_reader :availability_groups, :id

    # @param employee_id [Integer] The id of the employee to which this service belongs to
    # @param availability [Array<Array>] An array of length 7, containing the availability
    #   per hour for each day of the week for a certain employee
    # @description Stores an availability matrix and generates availability groups. An
    #   availability groups is a hash, containing a day, a start hour, and a size of continuous
    #   hours that a certain employee has available to work
    def initialize(employee_id, availability)
      @id = employee_id
      @availability_matrix = availability
      @availability_groups = []

      generate_availability_groups
    end

    # @param desired_size [Integer] The max size of the groups that we want to extract from a certain
    #   employee, regardless of day.
    # @return [Array<Hash>] An array of groups that have at most the desired size. Minimum size defaults to 2 since
    #   there is no point in swaping a 1 hour turn
    # @description Takes all the availability groups, and filters those that have a size greater or equal
    #   to the desired size
    def find_available_groups(desired_size = 2)
      @availability_groups.select { |group| group[:size] >= desired_size }
    end

    # @param day [Integer] The day of the week to be searched
    # @param start_hour [Integer] The starting hour in which we need the largest possible shift
    # @return [Array<Hash>] An array of groups sorted by how many hours can a person work starting
    #   on the "start_hour" value
    # @descriptions Takes all the availability groups that are on the day received as argument
    #   and that contain at least the "start_hour" within them, and sorts them by how many hours
    #   they cover.
    def find_group_on_shift(day, start_hour)
      selected_group = @availability_groups.find do |group|
        window_start = group[:start_hour]
        window_end = group[:start_hour] + group[:size]
        group[:day] == day && window_start <= start_hour && window_end > start_hour
      end

      return nil unless selected_group

      {
        employee_id: @id,
        size: selected_group[:size] + selected_group[:start_hour] - start_hour
      }
    end

    protected

    # @description generates all the availability groups based on the availability matrix of this employee,
    #   sorted ascending by size. Each availability groups is a hash with the following format: {
    #     day: Integer # The day of the week of the group
    #     start_hour: Integer # The index of the starting hour of the group
    #     size: Integer # The size of the group
    #     hours_list: Array<Integer> # Cache. It is an array of length "size", starting on "start_hour"
    #   }
    def generate_availability_groups
      @availability_matrix.each_with_index do |day, day_index|
        analyze_day_availability(day, day_index)
      end

      @availability_groups.sort_by! { |e| e[:size] }
      @availability_groups
    end

    # @param day [Array<Integer>] The day to be analized
    # @param day_index [Integer] The index of the day to be analyzed. Monday is 0, Tuesday is 1, and so on.
    # @description Goes through all the availability array of the current day, and creates groups of continuous
    #   hours an employee can work. For example, if the availability array is [nil, 3, 3, 3, nil, 3, 3], 2 groups
    #   can be created.
    def analyze_day_availability(day, day_index)
      availability_group = nil
      day.each_with_index do |is_available, hour_index|
        if is_available
          availability_group = add_to_group(availability_group, day_index, hour_index)
        elsif availability_group
          push_group(availability_group)
          availability_group = nil
        end
      end
      push_group(availability_group) if availability_group
    end

    # @param availability_group [Hash] The availability group to be pused to @availability_groups
    # @description Takes a complete availability_group and pushes it into the @availability_groups array
    def push_group(availability_group)
      availability_group[:hours_list] = Array.new(availability_group[:size]) { |i| i + availability_group[:start_hour] }
      @availability_groups.push(availability_group)
    end

    # @param availability_group [Hash] An incomplete availability_group
    # @param day_index [Integer] The index of the day that is being analized. The availability_group belongs
    #   to this day
    # @param hour_index [Integer] The index of the hour of the day that is being added to the group.
    # @description Adds a sigle hour to a group. This group will continue to group unless the day ends or a nil
    #   value is found, meaning the employee is not available on that hour. At that point, the group must be pushed
    #   into @availability_groups, and a new group must be created if the day is not over
    def add_to_group(availability_group, day_index, hour_index)
      if availability_group
        availability_group[:size] += 1
      else
        availability_group = { day: day_index, start_hour: hour_index, size: 1, employee_id: @id }
      end

      availability_group
    end
  end
end
