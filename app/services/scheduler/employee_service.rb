module Scheduler
  # Scheduler::EmployeeServices
  # Grous the availability of an employee, so it can always retrieve a day
  # the person can work the most
  class EmployeeService
    attr_reader :availability_groups

    # @param availability [Array<Array>] An array of length 7, containing the availability
    #   per hour for each day of the week for a certain employee
    # @description Stores an availability matrix and generates availability groups. An
    #   availability groups is a hash, containing a day, a start hour, and a size of continuous
    #   hours that a certain employee has available to work
    def initialize(availability)
      @availability_matrix = availability
      @availability_groups = []

      generate_availability_groups
    end

    # @param desired_size [Integer] The desired size of the groups that we want to extract from a certain
    #   employee, regardless of day.
    # @return [Array<Hash>] An array of groups that have at least the desired size
    # @description Takes all the availability groups, and filters those that have a size greater or equal
    #   to the desired size
    def find_available_groups(desired_size)
      @availability_groups.select { |group| group[:size] >= desired_size }
    end

    # finds one group for each employee, where their times match
    # so they can swap schedules
    def self.find_matching_group(employee_a_groups, employee_b_groups, size)
      employee_a_groups = employee_a_groups.sort_by { |e| e[:day] }
      employee_b_groups = employee_b_groups.sort_by { |e| e[:day] }

      index_a = 0
      index_b = 0

      while index_b < employee_b_groups.size && index_a < employee_b_groups.size
        day_a = employee_a_groups[index_a][:day]
        day_b = employee_b_groups[index_b][:day]

        if day_a == day_b
          matching_hours = (employee_a_groups[index_a][:hours_list] & employee_b_groups[index_b][:hours_list])
          if matching_hours.length >= size
            return {
              group_a: employee_a_groups[index_a],
              group_b: employee_b_groups[index_b],
              matching_hours: matching_hours.sort[0, size]
            }
          end
        end

        index_b += 1 if day_a >= day_b
        index_a += 1 if day_b > day_a

        return nil if index_b >= employee_b_groups.size || index_a >= employee_b_groups.size
      end
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
      availability_group[:hours_list] = Array.new(availability_group[:size]) { |i| i + availability_group[:start_hour]}
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
        availability_group = { day: day_index, start_hour: hour_index, size: 1}
      end

      availability_group
    end
  end
end
