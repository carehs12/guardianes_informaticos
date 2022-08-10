# OptimizerService
# calculates the distribution if shifts between employees
# to balance work time and minimize shift swaps
class OptimizerService
  attr_accessor :employee_services

  def initialize(availability_data, max_iters = 20)
    @max_iters = max_iters
    @num_employees = availability_data.size
    @availability_data = availability_data
    @employee_services = []
    @schedule_service = Optimizer::ScheduleService.new(7, @availability_data, @employee_services)
    @cost = { shift_swap: 0, hours_difference: 2_147_483_647 }

    initialize_daily_shifts
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

    @schedule_service.schedule
  end

  protected

  def execute_optimization_loop(current_cost)
    @max_iters.times do
      break unless shifts_swapped?

      calculate_costs
      new_cost = @cost[:shift_swap] + @cost[:hours_difference]
      if new_cost >= current_cost
        @schedule_service.set_schedule(@old_schedule)
        break
      end

      current_cost = new_cost
    end
  end

  def shifts_swapped?(freer_employee_offset = 0)
    return false if freer_employee_offset >= (@num_employees - 1)

    work_values = @schedule_service.work_hours.values.sort
    busiest_employee_id = @schedule_service.work_hours.key(work_values[-1])
    freer_employee_id = @schedule_service.work_hours.key(work_values[freer_employee_offset])

    return true if swap_shifts(busiest_employee_id, freer_employee_id)

    shifts_swapped?(freer_employee_offset + 1)
  end

  def swap_shifts(busiest_employee_id, freer_employee_id)
    swap_size_limit = calculate_swap_size_limit(busiest_employee_id)
    be_groups = @employee_services[busiest_employee_id].find_available_groups
    fe_groups = @employee_services[freer_employee_id].find_available_groups

    matching_groups = nil
    while matching_groups.nil?
      matching_groups = Optimizer::ScheduleService.find_matching_group(be_groups, fe_groups, swap_size_limit)
      swap_size_limit -= 1 unless matching_groups
      return false if swap_size_limit.zero?
    end

    record_and_swap_shifts(matching_groups)
  end

  def calculate_swap_size_limit(busiest_employee_id)
    swap_size_limit = @schedule_service.schedule.map do |day|
      scheduled_hours = day.find_all { |employee_id| employee_id == busiest_employee_id }
      scheduled_hours.size
    end

    halved_cost = @cost[:hours_difference] / 2
    swap_size_limit.max >= halved_cost ? halved_cost : swap_size_limit.max
  end

  def record_and_swap_shifts(matching_groups)
    @old_schedule = JSON.parse(@scheduler_service.schedule.to_json)
    @schedule_service.record_shift_swap(matching_groups)
  end

  def initialize_daily_shifts
    @time_windows = Array.new(7, 0)

    @availability_data[0].each_with_index do |employee_data, index|
      @time_windows[index] = employee_data.size
    end
  end

  def calculate_costs
    flat_schedule = @schedule_service.schedule.flatten

    calculate_hour_difference_cost(flat_schedule)
    calculate_shift_swap_cost(flat_schedule)
  end

  def calculate_hour_difference_cost(flat_schedule)
    (0..(@num_employees - 1)).each do |employee_index|
      employee_hours = flat_schedule.select { |employee| employee == employee_index }

      @schedule_service.work_hours[employee_index] = employee_hours.length
    end

    sorted_hours = @schedule_service.work_hours.values.sort
    @cost[:hours_difference] = sorted_hours[-1] - sorted_hours[0]
  end

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
