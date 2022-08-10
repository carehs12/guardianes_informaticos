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

    # @param employee_a_groups [Array<Hash>] The filtered groups of an "a" employee, as returned by
    #   find_available_groups
    # @param employee_b_groups [Array<Hash>] The filtered groups of a "b" employee, as returned by
    # @param size [Integer] The minimum size the time window has to have to be able to swap schedules
    #   find_available_groups. Please note that this will work if a == b, but the output won't be useful
    # @param index_a [Integer] The index of the first array of groups
    # @param index_b [Integer] The index of the second array of groups
    # @return [Hash] An array containing the following format: {
    #     group_a: Hash # The selected group of the first employee
    #     group_b: Hash # The selected group of the second employee
    #     matching_hours: Hash # The indexes of the continuous hours on each group (a and b) that can be swapped
    #   }
    # @description Searches both groups in order until 2 groups are found that are on the same day and
    #   have the same time windows for both employees. This allows both employees to swap schedules without issues. If
    #   no group is found, then nil is returned instead.
    def self.find_matching_group(employee_a_groups, employee_b_groups, size, groups_a_index = 0, groups_b_index = 0)
      employee_a_groups = employee_a_groups.sort_by { |e| e[:day] }
      employee_b_groups = employee_b_groups.sort_by { |e| e[:day] }
      index_a, index_b = align_group_indexes(employee_a_groups, employee_b_groups, groups_a_index, groups_b_index)
      return nil if index_a.nil?

      matching_hours = find_matching_hours(employee_a_groups, employee_b_groups, size, index_a, index_b)
      return matching_hours if matching_hours

      find_matching_group(employee_a_groups, employee_b_groups, size, index_a + 1, index_b)
    end

    # @param employee_a_groups [Array<Hash>] The filtered groups of an "a" employee, as returned by
    #   find_available_groups
    # @param employee_b_groups [Array<Hash>] The filtered groups of a "b" employee, as returned by
    #   find_available_groups. Please note that this will work if a == b, but the output won't be useful
    # @param index_a [Integer] The index of the first array of groups
    # @param index_b [Integer] The index of the second array of groups
    # @param size [Integer] The minimum size the time window has to have to be able to swap schedules
    # @return [Hash] An array containing the following format: {
    #   group_a: Hash # The selected group of the first employee
    #   group_b: Hash # The selected group of the second employee
    #   matching_hours: Hash # The indexes of the continuous hours on each group (a and b) that can be swapped
    # }
    # @description takes the groups on each specified index and verifies if how many continous hours match between
    #   the two groups. If the amount of matching hours is greater or equal to the specified size, the hash is returned
    #   otherwise, nil is returned instead
    def self.find_matching_hours(employee_a_groups, employee_b_groups, size, index_a, index_b)
      matching_hours = (employee_a_groups[index_a][:hours_list] & employee_b_groups[index_b][:hours_list])
      if matching_hours.length >= size
        return {
          group_a: employee_a_groups[index_a],
          group_b: employee_b_groups[index_b],
          matching_hours: matching_hours.sort[0, size]
        }
      end

      nil
    end

    # @param employee_a_groups [Array<Hash>] The filtered groups of an "a" employee, as returned by
    #   find_available_groups
    # @param employee_b_groups [Array<Hash>] The filtered groups of a "b" employee, as returned by
    #   find_available_groups. Please note that this will work if a == b, but the output won't be useful
    # @param index_a [Integer] The starting index of the first array of groups
    # @param index_b [Integer] The starting index of the second array of groups
    # @return [Array<Integer>] An array containing the 2 new indexes of each array of groups that represents
    #   the first element in which they share a common day. If no matching groups can be found, nil is returned
    #   instead
    # @description Searches the groups arrays, finding the first element of each in which the days match.
    #   It is on this day, that the employees can swap assigned schedules, if the hours also match.
    def self.align_group_indexes(employee_a_groups, employee_b_groups, index_a, index_b)
      day_a = employee_a_groups[index_a][:day]
      day_b = employee_a_groups[index_b][:day]

      while index_b < employee_b_groups.size && index_a < employee_b_groups.size
        return [index_a, index_b] if day_a == day_b

        index_a, index_b = move_lesser_index_forward(day_a, day_b, index_a, index_b)
        return nil if index_b >= employee_b_groups.size || index_a >= employee_b_groups.size
      end
    end

    # @param day_a [Integer] The day of the group of the first employee that is being analyzed
    # @param day_b [Integer] The day of the group of the second employee that is being analyzed
    # @param index_a [Integer] The starting index of the first array of groups
    # @param index_b [Integer] The starting index of the second array of groups
    # @return [Array<Integer>] An array containing the 2 new indexes of each array of groups. One index
    #   will remain the same, while the other index will be moved forward one space
    # @descriptions. Checks the day of the first and second group, and moves forward the index of the day
    #   that is behind, meaning, closer to monday.
    def self.move_lesser_index_forward(day_a, day_b, index_a, index_b)
      if day_a >= day_b
        index_b += 1
      else
        index_a += 1
      end

      [index_a, index_b]
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
        availability_group = { day: day_index, start_hour: hour_index, size: 1 }
      end

      availability_group
    end

    protected_methods :align_group_indexes
    protected_methods :move_lesser_index_forward
    protected_methods :find_matching_hours

  end
end
