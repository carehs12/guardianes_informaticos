module Optimizer
  # My comment
  class ScheduleService
    attr_accessor :schedule, :work_hours

    def initialize(num_days, availability_data, employee_services)
      @work_hours = {}
      @availability_data = availability_data
      @employee_services = employee_services
      @schedule = Array.new(num_days)
      @schedule = @schedule.map { [] }
    end

    def initialize_employee_availabilities
      @availability_data.each_with_index do |employee_data, employee_id|
        @employee_services.push(EmployeeService.new(employee_id, employee_data))
      end
    end

    def autofill_shifts(time_windows)
      day_index = 0
      hour_index = 0
      while day_index < 7
        hour_index = fill_shift(day_index, hour_index) while hour_index < time_windows[day_index]
        hour_index = 0
        day_index += 1
      end
    end

    def record_shift_swap(matching_groups)
      new_group = matching_groups[:unscheduled_group]

      new_shift = Array.new(new_group[:size], new_group[:employee_id])
      @schedule[new_group[:day]][new_group[:start_hour], new_group[:size]] = new_shift
    end

    def fill_shift(day_index, hour_index)
      available_shifts = @employee_services.map { |employee| employee.find_group_on_shift(day_index, hour_index) }
      available_shifts.compact!
      available_shifts.sort_by! { |e| e[:size] }
      return (hour_index + 1) if available_shifts.size.zero?

      longest_shift = available_shifts[-1]
      add_employee_to_schedule(day_index, hour_index, longest_shift)
      hour_index + longest_shift[:size]
    end

    # @param scheduled_groups [Array<Hash>] The filtered groups of an "a" employee, as returned by
    #   find_available_groups. This employee has to be currently scheduled
    # @param unscheduled_groups [Array<Hash>] The filtered groups of a "b" employee, as returned by
    # @param size [Integer] The minimum size the time window has to have to be able to swap schedules
    #   find_available_groups. Please note that this will work if a == b, but the output won't be useful
    # @param index_a [Integer] The index of the first array of groups. Must be zero when called from outside
    # @param index_b [Integer] The index of the second array of groups. Must be zero when called from outside
    # @return [Hash] An array containing the following format: {
    #     group_a: Hash # The selected group of the first employee
    #     group_b: Hash # The selected group of the second employee
    #     matching_hours: Hash # The indexes of the continuous hours on each group (a and b) that can be swapped
    #   }
    # @description Searches both groups in order until 2 groups are found that are on the same day and
    #   have the same time windows for both employees. This allows both employees to swap schedules without issues. If
    #   no group is found, then nil is returned instead.
    def self.find_matching_group(scheduled_groups, unscheduled_groups, size, groups_a_index = 0, groups_b_index = 0)
      scheduled_groups = scheduled_groups.sort_by { |e| e[:day] }
      unscheduled_groups = unscheduled_groups.sort_by { |e| e[:day] }
      index_a, index_b = align_group_indexes(scheduled_groups, unscheduled_groups, groups_a_index, groups_b_index)
      return nil if index_a.nil?

      matching_hours = find_matching_hours(scheduled_groups, unscheduled_groups, size, index_a, index_b)
      return matching_hours if matching_hours

      find_matching_group(scheduled_groups, unscheduled_groups, size, index_a + 1, index_b)
    end

    # @param scheduled_groups [Array<Hash>] The filtered groups of an "a" employee, as returned by
    #   find_available_groups. This employee has to be currently scheduled
    # @param unscheduled_groups [Array<Hash>] The filtered groups of a "b" employee, as returned by
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
    def self.find_matching_hours(scheduled_groups, unscheduled_groups, size, index_a, index_b)
      matching_hours = (scheduled_groups[index_a][:hours_list] & unscheduled_groups[index_b][:hours_list])
      if matching_hours.length >= size
        matching_hours = matching_hours.sort[0, size]
        if selected_group_scheduled?(@schedule, scheduled_groups[index_a], matching_hours)
          return matching_hour_data(scheduled_groups, unscheduled_groups, index_a, index_b, matching_hours)
        end
      end

      nil
    end

    def self.selected_group_scheduled?(schedule, scheduled_group, matching_hours)
      subschedule = schedule[scheduled_group[:day]][scheduled_group[:start_hour], matching_hours.size]
      Array.new(matching_hours.size, scheduled_group[:employee_id]).eql? subschedule
    end

    # @param scheduled_groups [Array<Hash>] The filtered groups of an "a" employee, as returned by
    #   find_available_groups
    # @param unscheduled_groups [Array<Hash>] The filtered groups of a "b" employee, as returned by
    #   find_available_groups. Please note that this will work if a == b, but the output won't be useful
    # @param index_a [Integer] The starting index of the first array of groups
    # @param index_b [Integer] The starting index of the second array of groups
    # @return [Array<Integer>] An array containing the 2 new indexes of each array of groups that represents
    #   the first element in which they share a common day. If no matching groups can be found, nil is returned
    #   instead
    # @description Searches the groups arrays, finding the first element of each in which the days match.
    #   It is on this day, that the employees can swap assigned schedules, if the hours also match.
    def self.align_group_indexes(scheduled_groups, unscheduled_groups, index_a, index_b)
      while index_b < unscheduled_groups.size && index_a < unscheduled_groups.size
        day_a = scheduled_groups[index_a][:day]
        day_b = unscheduled_groups[index_b][:day]
        return [index_a, index_b] if day_a == day_b

        index_a, index_b = move_lesser_index_forward(day_a, day_b, index_a, index_b)
        return nil if index_b >= unscheduled_groups.size || index_a >= unscheduled_groups.size
      end
    end

    def matching_hour_data(scheduled_groups, unscheduled_groups, index_a, index_b, matching_hours)
      {
        scheduled_group: scheduled_groups[index_a],
        unscheduled_group: unscheduled_groups[index_b],
        matching_hours: matching_hours
      }
    end

    protected

    def add_employee_to_schedule(day_index, hour_index, selected_shift)
      shift_size = selected_shift[:size]
      shift_employee = selected_shift[:employee_id]
      @schedule[day_index][hour_index, shift_size] = Array.new(shift_size, shift_employee)
    end

    protected_methods :find_matching_hours
    protected_methods :selected_group_scheduled
    protected_methods :align_group_indexes
    protected_methods :move_lesser_index_forward
  end
end
