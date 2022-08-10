# SchedulerServices
# calculates the distribution if shifts between employees
# to balance work time and minimize shift swaps
class SchedulerService
  attr_accessor :employees_data, :work_hours

  def initialize(availability_data, max_iters = 20)
    @max_iters = max_iters
    @num_employees = availability_data.size
    @schedule = [[], [], [], [], [], [], []]
    @work_hours = {}
    @cost = { shift_swap: 0, hours_difference: 2_147_483_647 }
    @availability_data = availability_data
    @employees_data = []

    initialize_daily_shifts
    initialize_employee_availabilities
  end

  # @return [Array<Array<Integer>>] An array of dimensions 7*n_i where
  #   n_i is the number of shift hours on the ith day
  # @description Analyzes the shift data of every employee, and selects
  #   the configuration that minimizes shift changes and balances hours
  #   worked per employee while also covering all time windows
  #   (if there is at least one employee available)
  def optimize_shifts
    autofill_shifts
    calcualate_costs
    current_cost = @cost[:shift_swap] + @cost[:hours_difference]

    execute_optimization_loop(current_cost)

    calcualate_costs
    @schedule
  end

  protected

  def execute_optimization_loop(current_cost)
    @max_iters.times do |iter|
      break unless shifts_swapped?

      calcualate_costs
      new_cost = @cost[:shift_swap] + @cost[:hours_difference]
      puts "SCHEDULE AFTER ITER #{iter}: #{@schedule.to_json}"
      puts "COST AFTER ITER #{iter} - #{@cost}"
      puts "WORK HOURS: #{@work_hours.to_json}"
      puts "----------------------------------------------------------"
      puts "----------------------------------------------------------"
      if new_cost >= current_cost
        @schedule = @old_schedule
        break
      end

      current_cost = new_cost
    end
  end

  def shifts_swapped?(freer_employee_offset = 0)
    return false if freer_employee_offset >= (@num_employees - 1)

    work_values = @work_hours.values.sort
    busiest_employee_id = @work_hours.key(work_values[-1])
    freer_employee_id = @work_hours.key(work_values[freer_employee_offset])

    return true if swap_shifts(busiest_employee_id, freer_employee_id)

    shifts_swapped?(freer_employee_offset + 1)
  end

  def swap_shifts(busiest_employee_id, freer_employee_id)
    swap_size_limit = calculate_swap_size_limit(busiest_employee_id)
    puts "ATEMPTING SWAP SIZE LIMIT AT #{swap_size_limit}"
    be_groups = @employees_data[busiest_employee_id].find_available_groups
    fe_groups = @employees_data[freer_employee_id].find_available_groups

    matching_groups = nil
    while matching_groups.nil?
      matching_groups = Scheduler::EmployeeService.find_matching_group(@schedule, be_groups, fe_groups, swap_size_limit)
      swap_size_limit -= 1 unless matching_groups
      return false if swap_size_limit.zero?
    end

    record_shift_swap(matching_groups)
  end

  def record_shift_swap(matching_groups)
    new_group = matching_groups[:unscheduled_group]
    @old_schedule = JSON.parse(@schedule.to_json)

    new_shift = Array.new(new_group[:size], new_group[:employee_id])
    @schedule[new_group[:day]][new_group[:start_hour], new_group[:size]] = new_shift
  end

  def calculate_swap_size_limit(busiest_employee_id)
    swap_size_limit = @schedule.map do |day|
      scheduled_hours = day.find_all { |employee_id| employee_id == busiest_employee_id }
      scheduled_hours.size
    end

    halved_cost = @cost[:hours_difference] - 1
    swap_size_limit.max >= halved_cost ? halved_cost : swap_size_limit.max
  end

  def initialize_employee_availabilities
    @availability_data.each_with_index do |employee_data, employee_id|
      @employees_data.push(Scheduler::EmployeeService.new(employee_id, employee_data))
    end
  end

  def initialize_daily_shifts
    @time_windows = Array.new(7, 0)

    @availability_data[0].each_with_index do |employee_data, index|
      @time_windows[index] = employee_data.size
    end
  end

  def autofill_shifts
    day_index = 0
    hour_index = 0
    while day_index < 7
      hour_index = fill_shift(day_index, hour_index) while hour_index < @time_windows[day_index]
      hour_index = 0
      day_index += 1
    end
  end

  def fill_shift(day_index, hour_index)
    available_shifts = @employees_data.map { |employee| employee.find_group_on_shift(day_index, hour_index) }
    available_shifts.compact!
    available_shifts.sort_by! { |e| e[:size] }
    return (hour_index + 1) if available_shifts.size.zero?

    longest_shift = available_shifts[-1]
    add_employee_to_schedule(day_index, hour_index, longest_shift)
    hour_index + longest_shift[:size]
  end

  def add_employee_to_schedule(day_index, hour_index, selected_shift)
    shift_size = selected_shift[:size]
    shift_employee = selected_shift[:employee_id]
    @schedule[day_index][hour_index, shift_size] = Array.new(shift_size, shift_employee)
  end

  def calcualate_costs
    flat_schedule = @schedule.flatten

    calculate_hour_difference_cost(flat_schedule)
    calculate_shift_swap_cost(flat_schedule)
  end

  def calculate_hour_difference_cost(flat_schedule)
    (0..(@num_employees - 1)).each do |employee_index|
      employee_hours = flat_schedule.select { |employee| employee == employee_index }

      @work_hours[employee_index] = employee_hours.length
    end

    sorted_hours = @work_hours.values.sort
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
