# OptimizerService
# calculates the distribution of shifts between employees
# to balance work time and minimize shift swaps
class OptimizerService
  attr_accessor :employee_services, :schedule_service

  # @param availability_data [Array<Array<Array<Integer>>>] 3-dimensional matrix that contains in the
  #   first index the info of each employee. On the second index, the 7 days of the week, and
  #   on the third index, if the employee is available for work at that specific hour on that
  #   specific day
  # @param max_iters [Integer] Watchdog in case something goes wrong, prevents an infinite loop do
  #   while looking for an optimal solution
  # @description initializes the sevice and it's children services, one for each employee, and
  #   one for the general schedule
  def initialize(availability_data, max_iters = 20)
    @max_iters = max_iters
    @num_employees = availability_data.size
    @availability_data = availability_data
    @employee_services = []
    @schedule_service = Optimizer::ScheduleService.new(7, @availability_data, @employee_services)
    @cost = { shift_swap: 0, hours_difference: 2_147_483_647 }

    initialize_time_windows
    @schedule_service.initialize_employee_availabilities
  end

  # @return [Array<Array<Integer>>] An array of dimensions 7*n_i where
  #   n_i is the number of shift hours on the ith day
  # @description Analyzes the shift data of every employee, and selects
  #   the configuration that minimizes shift changes and balances hours
  #   worked per employee while also covering all time windows
  #   (if there is at least one employee available)
  def optimize_shifts
    @schedule_service.autofill_shifts(@time_windows)
    calculate_costs
    current_cost = @cost[:shift_swap] + @cost[:hours_difference]

    execute_optimization_loop(current_cost)
    calculate_costs

    @schedule_service.schedule
  end

  protected

  # @param current_cost [Integer] The cost of the current schedule.
  # @description Executes an opimization loop, selecting the busiest and
  #   freer employees, and swapping one time shift between them.
  def execute_optimization_loop(current_cost)
    @max_iters.times do
      break unless shifts_swapped?

      calculate_costs
      new_cost = @cost[:shift_swap] + @cost[:hours_difference]
      if new_cost >= current_cost
        @schedule_service.schedule = @old_schedule
        break
      end

      current_cost = new_cost
    end
  end

  # @param freer_employee_offset [Integer] The offset of the employee selected
  #   to be the one to swap shifts with the busiest employee. Ideally, this is the
  #   employee with least hours, but, if no time windows match between busiest/freer
  #   employees, another one is selected
  # @return [Boolean] wheter the shift swap was successful or not
  # @description selects the busiest and freer employees that have one schedule in common
  #   and attempts to perform a shift swap between them. If it not possible, another freer
  #   employee is selected
  def shifts_swapped?(freer_employee_offset = 0)
    return false if freer_employee_offset >= (@num_employees - 1)

    work_values = @schedule_service.work_hours.values.sort
    busiest_employee_id = @schedule_service.work_hours.key(work_values[-1])
    freer_employee_id = @schedule_service.work_hours.key(work_values[freer_employee_offset])

    return true if swap_shifts(busiest_employee_id, freer_employee_id)

    shifts_swapped?(freer_employee_offset + 1)
  end

  # @param busiest_employee_id [Integer] The id of the employee that currently has more weekly
  #   hours assigned
  # @param freer_employee_id [Integer] The id of the employee that currently has less weekly hors
  #   assigned
  # @return [Boolean] If the shift swap was successful or not
  # @description Attempts to find an availability group in which both the busiest and freer employees
  #   share availability, where also the busiest employee is currently assigned. If these groups match
  #   then these employees swap shifts
  def swap_shifts(busiest_employee_id, freer_employee_id)
    swap_size_limit = calculate_swap_size_limit(busiest_employee_id)
    be_groups = @employee_services[busiest_employee_id].find_available_groups
    fe_groups = @employee_services[freer_employee_id].find_available_groups

    matching_groups = nil
    while matching_groups.nil?
      matching_groups = @schedule_service.find_matching_group(be_groups, fe_groups, swap_size_limit)
      swap_size_limit -= 1 unless matching_groups
      return false if swap_size_limit.zero?
    end

    record_and_swap_shifts(matching_groups)
  end

  # @param busiest_employee_id [Integer] The id of the employee that currently has more weekly
  #   hours assigned
  # @return [Integer] The maximum swap size to be searched for.
  # @description Checks which is the longest shift the busiest employee works, and counts how
  #   many continuos hours do they work. Then selects the smallest number: these amount of continous
  #   hours, or the difference in hours between busiest and freest employee minus 1. The minus 1 is important
  #   because if that weren't there, then when swapping, the freer employee would pass to be the busiest and
  #   vice versa.
  def calculate_swap_size_limit(busiest_employee_id)
    swap_size_limit = @schedule_service.schedule.map do |day|
      scheduled_hours = day.find_all { |employee_id| employee_id == busiest_employee_id }
      scheduled_hours.size
    end

    hours_difference = @cost[:hours_difference] - 1
    swap_size_limit.max >= hours_difference ? hours_difference : swap_size_limit.max
  end

  # @param matching_groups [Hash] Hash containing the two selected groups, from each employee, that
  #   fullfill all requirements, meaning. They belong to the same day, in the same time window, and
  #   the current schedule assigns that time window to the busiest employee.
  # @description stores the old schedule in case the new schedule is less efficient, and proceeds to
  #   swap shifts between the two selected employees
  def record_and_swap_shifts(matching_groups)
    @old_schedule = JSON.parse(@schedule_service.schedule.to_json)
    @schedule_service.record_shift_swap(matching_groups)
  end

  # @description Sets the @time_windows variable. This  variable contains how many hours are there in
  #   a day
  def initialize_time_windows
    @time_windows = Array.new(7, 0)

    @availability_data[0].each_with_index do |employee_data, index|
      @time_windows[index] = employee_data.size
    end
  end

  # @description Calculates the cost of the current schedule. The cost is divided in two parts: the first part
  #   is how many hours does the busiest employee work over the freest employee. The second part is how many
  #   shift swaps are there on the schedule. A shift swap occurs when the employee in charge, changes
  def calculate_costs
    flat_schedule = @schedule_service.schedule.flatten

    calculate_hour_difference_cost(flat_schedule)
    calculate_shift_swap_cost(flat_schedule)
  end

  # @param flat_schedule [Array<Integer>] A flattend version of the array. It is flattened because every day
  #   has the same weight on the final cost, and simplifies calculations
  # @description Calculates how many hours does the busiest employee work over the freest employee.
  def calculate_hour_difference_cost(flat_schedule)
    (0..(@num_employees - 1)).each do |employee_index|
      employee_hours = flat_schedule.select { |employee| employee == employee_index }

      @schedule_service.work_hours[employee_index] = employee_hours.length
    end

    sorted_hours = @schedule_service.work_hours.values.sort
    @cost[:hours_difference] = sorted_hours[-1] - sorted_hours[0]
  end

  # @param flat_schedule [Array<Integer>] A flattend version of the array. It is flattened because every day
  #   has the same weight on the final cost, and simplifies calculations
  # @description Calculates how many shift swaps are there on the current schedule
  def calculate_shift_swap_cost(flat_schedule)
    shift_swap_cost = 0
    flat_schedule.each_with_index do |current_employee, index|
      previous_employee = flat_schedule[index - 1]
      next if index.zero? || current_employee.nil?
      next if previous_employee.nil?

      shift_swap_cost += 1 unless current_employee == previous_employee
    end

    @cost[:shift_swap] = shift_swap_cost
  end
end
