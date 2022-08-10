namespace :test do
  desc 'Do Stuff'
  task analyze_user: :environment do
    x = [
      [
        [0, 0, nil],
        [0, 0, 0],
        [nil, nil, nil],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, nil, nil],
        [nil, nil, 0, 0, 0, 0, 0]
      ],[
        [1, 1, 1],
        [nil, 1, 1],
        [nil, nil, 1],
        [1, 1, 1, nil, nil],
        [1, nil, 1, nil, 1],
        [1, 1, 1, 1, 1, 1, 1],
        [nil, nil, 1, 1, 1, nil, 1]
      ],[
        [2, 2, nil],
        [nil, 2, nil],
        [2, 2, 2],
        [2, 2, 2, 2, 2],
        [nil, 2, nil, nil, 2],
        [2, nil, 2, 2, 2, 2, 2],
        [nil, nil, 2, 2, 2, nil, 2]
      ]
    ]
    scheduler = SchedulerService.new(x)
    scheduler.optimize_shifts
=begin
    employee_service1 = Scheduler::EmployeeService.new(
      [
        [nil, nil, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, nil, nil, 0, 0],
        [nil, 0, 0, 0, nil, nil],
        [0, 0, 0, 0, 0, nil],
        [0, nil, 0, nil, 0, nil],
        [nil, 0, 0, 0, 0, 0]
      ]
    )

    @data = [
      [nil, nil, 1], [nil, nil, 1], [nil, nil, 1], [nil, nil, 1], [nil, nil, 1], [0, 1, 1],
      [0, 1, 1], [0, 1, 1], [0, 1, 1], [0, 1, 1], [nil, 1, 1], [nil, 1, 1], [nil, 1, 1],
      [nil, 1, 1], [nil, 1, 1], [0, 1, 1], [0, 1, 1], [0, 1, 1], [0, 1, 1], [0, 1, 1], [0, 1, nil],
      [0, 1, nil], [0, 1, nil], [0, 1, nil], [0, 1, nil], [0, nil, nil], [0, nil, nil], [0, nil, nil],
      [0, nil, nil], [0, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, 1, 1],
      [nil, 1, 1], [nil, 1, 1], [nil, nil, 1], [nil, nil, 1], [nil, nil, 1], [nil, 1, nil], [nil, 1, nil],
      [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil],
      [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil], [nil, 1, nil]
    ]

    employee_service1 = Scheduler::EmployeeService.new(
      [
        [nil, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [nil, nil, 0, 0, 0, 0],
        [0, 0, nil, nil, 0, 0],
        [nil, 0, 0, 0, nil, nil],
        [0, 0, 0, 0, 0, nil],
        [0, nil, 0, nil, 0, nil],
      ]
    )

    puts employee_service1.availability_groups.to_json
    puts employee_service1.find_available_groups(1).to_json
    puts '------------------------------'
    puts employee_service1.availability_groups.to_json
    puts employee_service1.find_available_groups(1).to_json

    puts "result!"
    groups1 = employee_service1.find_available_groups(1)
    groups1 = employee_service1.find_available_groups(1)
    puts Scheduler::EmployeeService.find_matching_group(groups1, groups1, 1)
=end
  end
end
