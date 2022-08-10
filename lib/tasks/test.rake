namespace :test do
  desc 'Do Stuff'
  task analyze_user: :environment do
    x = [
      [
        [0, 0, nil],
        [0, 0, 0],
        [nil, nil, nil],
        [0, 0, 0, 0, 0],
        [0, nil, 0, 0, 0],
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
    optimizer = OptimizerService.new(x)
    schedule = optimizer.optimize_shifts
    puts 'SCHEDULE IS'
    puts schedule.to_json
    puts optimizer.schedule_service.work_hours.to_json
    # employee_service1 = Scheduler::EmployeeService.new(
    #   [
    #     [nil, nil, 0, 0, 0, 0],
    #     [0, 0, 0, 0, 0, 0],
    #     [0, 0, nil, nil, 0, 0],
    #     [nil, 0, 0, 0, nil, nil],
    #     [0, 0, 0, 0, 0, nil],
    #     [0, nil, 0, nil, 0, nil],
    #     [nil, 0, 0, 0, 0, 0]
    #   ]
    # )

    # employee_service2 = Scheduler::EmployeeService.new(
    #   [
    #     [nil, 1, 1, 1, 1, 1],
    #     [1, 1, 1, 1, 1, 1],
    #     [nil, nil, 1, 1, 1, 1],
    #     [1, 1, nil, nil, 1, 1],
    #     [nil, 1, 1, 1, nil, nil],
    #     [1, 1, 1, 1, 1, nil],
    #     [1, nil, 1, nil, 1, nil],
    #   ]
    # )

    # puts employee_service1.availability_groups.to_json
    # puts employee_service1.find_available_groups_of_size(3).to_json
    # puts '------------------------------'
    # puts employee_service2.availability_groups.to_json
    # puts employee_service2.find_available_groups_of_size(3).to_json

    # # puts 'result!'
    # groups1 = employee_service1.find_available_groups_of_size(3)
    # groups2 = employee_service2.find_available_groups_of_size(3)

    # puts 'xx'
    # puts employee_service1.find_group_on_shift(0, 2)
    # puts 'xx'
    # puts employee_service1.find_group_on_shift(1, 1)
    # puts 'xx'
    # puts employee_service1.find_group_on_shift(6, 4)
    # puts 'xx'
    # puts employee_service1.find_group_on_shift(0, 0)
    # puts 'xx'
    # puts Scheduler::EmployeeService.find_matching_group(groups1, groups2, 3)
  end
end
