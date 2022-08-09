# SchedulerServices
# calculates the distribution if shifts between employees
# to balance work time and minimize shift swaps
class SchedulerService
  attr_accessor :data

  def initialize(max_iters = 20)
    @max_iters = max_iters
    # @TODO: Change this method afterwards
    initialize_data
    # Fixed size of 7 days
    @schedule = Array.new(7)
    # When the scheduler is created, the cost is the max possible
    @hour_difference_cost = 2_147_483_647
    @shift_swap_cost = 0
    @num_employees = @data[0].size
    @work_hours = {}

    @data.map.with_index do |day, index|
      @schedule[index] = Array.new(day.length)
    end
  end

  # @return [Array[Array[Integer]]] An array of dimensions 7*n_i where
  #   n_i is the number of shift hours on the ith day
  # @description Analyzes the shift data of every employee, and selects
  #   the configuration that minimizes shift changes and balances hours
  #   worked per employee while also covering all time windows
  #   (if there is at least one employee available)
  def optimize_shifts
    current_cost = @shift_swap_cost + @hour_difference_cost

    @max_iters.times do |iter|
      puts "Iter #{iter} of #{@max_iters}"
      autofill_shifts
      calculate_schedule_cost
      new_cost = @shift_swap_cost + @hour_difference_cost

      break if new_cost >= current_cost

      current_cost = new_cost
    end

    # #TODO: remove this also
    display_results
  end

  protected

  def display_results
    puts "Current hour difference cost is = #{@hour_difference_cost}"
    puts "Current shift swap cost is = #{@shift_swap_cost}"
    puts @work_hours.to_json
    puts 'SCHEDULE IS'
    puts @schedule.to_json
  end

  def initialize_data
    # @TODO: This is dummy hardcoded data to use on a proof of concept
    @data = [
      [nil, nil, 2], [nil, nil, 2], [nil, nil, 2], [nil, nil, 2], [nil, nil, 2], [0, 1, 2],
      [0, 1, 2], [0, 1, 2], [0, 1, 2], [0, 1, 2], [nil, 1, 2], [nil, 1, 2], [nil, 1, 2],
      [nil, 1, 2], [nil, 1, 2], [0, 1, 2], [0, 1, 2], [0, 1, 2], [0, 1, 2], [0, 1, 2], [0, 1, nil],
      [0, 1, nil], [0, 1, nil], [0, 1, nil], [0, 1, nil], [0, nil, nil], [0, nil, nil], [0, nil, nil],
      [0, nil, nil], [0, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, 1, 2],
      [nil, 1, 2], [nil, 1, 2], [nil, nil, 2], [nil, nil, 2], [nil, nil, 2], [nil, 1, nil], [nil, 1, nil],
      [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil],
      [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil]
    ]
  end

  def autofill_shifts
    @data.map.with_index do |time_window, time_window_index|
      @schedule[time_window_index] = time_window.detect { |employee| employee }
    end
  end

  def calculate_schedule_cost
    calculate_hour_difference_cost
    calculate_shift_swap_cost
  end

  def calculate_hour_difference_cost
    flat_schedule = @schedule.flatten
    (0..(@num_employees - 1)).each do |employee_index|
      employee_hours = flat_schedule.select { |employee| employee == employee_index }

      @work_hours[employee_index] = employee_hours.length
    end

    sorted_hours = @work_hours.values.sort
    @hour_difference_cost = sorted_hours[-1] - sorted_hours[0]
  end

  def calculate_shift_swap_cost
    shift_swap_cost = 0
    @schedule.each_with_index do |current_employee, index|
      previous_employee = @schedule[index - 1]
      next if index.zero? || current_employee.nil?
      next if previous_employee.nil?

      shift_swap_cost += 1 unless current_employee == previous_employee
    end

    @shift_swap_cost = shift_swap_cost
  end
end
