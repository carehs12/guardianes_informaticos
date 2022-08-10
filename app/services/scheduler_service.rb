# SchedulerServices
# calculates the distribution if shifts between employees
# to balance work time and minimize shift swaps
class SchedulerService
  attr_accessor :employees_data

  def initialize(availability_data, max_iters = 20)
    @max_iters = max_iters
    @num_employees = availability_data.size
    @schedule = [[], [], [], [], [], [], []]
    @work_hours = {}
    @cost = { shift_swap: 0, hours_difference: 2_147_483_647 }
    @availability_data = availability_data
    @employees_data = {}

    initialize_time_windows
    initialize_employees_data
  end

  # @return [Array<Array<Integer>>] An array of dimensions 7*n_i where
  #   n_i is the number of shift hours on the ith day
  # @description Analyzes the shift data of every employee, and selects
  #   the configuration that minimizes shift changes and balances hours
  #   worked per employee while also covering all time windows
  #   (if there is at least one employee available)
  def optimize_shifts
    current_cost = @cost[:shift_swap] + @cost[:hours_difference]

    @max_iters.times do |iter|
      puts "Iter #{iter} of #{@max_iters}"
      autofill_shifts
      puts "Schedule calculated!"
      puts @schedule.to_json
      calculate_schedule_cost
      new_cost = @cost[:shift_swap] + @cost[:hours_difference]

      break if new_cost >= current_cost

      current_cost = new_cost
    end

    # #TODO: remove this also
    display_results
  end

  protected

  def initialize_employees_data
    @availability_data.map.with_index do |employee_data, employee_id|
      @employees_data[employee_id] = Scheduler::EmployeeService.new(employee_data)
    end
  end

  def initialize_time_windows
    @time_windows = Array.new(7, 0)

    @availability_data[0].each_with_index do |employee_data, index|
      @time_windows[index] = employee_data.size
    end

    puts "Time windows initialized: #{@time_windows.to_json}"
  end

  def display_results
    puts "Current hour difference cost is = #{@cost[:hours_difference]}"
    puts "Current shift swap cost is = #{@cost[:shift_swap]}"
    puts @work_hours.to_json
    puts 'SCHEDULE IS'
    puts @schedule.to_json
  end

  def autofill_shifts
    (0..6).each do |day_index|
      (0..(@time_windows[day_index] - 1)).each do |hour_index|
        hourly_availability = @availability_data.collect do |subarray|
          subarray[day_index][hour_index]
        end

        @schedule[day_index][hour_index] = hourly_availability.detect { |employee| employee.is_a? Numeric }
      end
    end
  end

  def calculate_schedule_cost
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
