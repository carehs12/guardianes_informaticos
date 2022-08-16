# Guardianes Informáticos

## Implemented Solution

### Asumptions

  Once the problem has been described, we proceed to solve it in a systemic way.
  The algorithm consists of two parts: an initial valid solution, and a series 
  of iterations that will optimize that solution to both reduce the difference in
  hours between the employees, and try to reduce the number of times a person is
  swapped on the same day.

  For the algorithm to work under any circunstance, we have to establish two asumptions:
    
  1. The week has 7 days always, and the shifts are 24 hours always. The algorithm
    doesn't care if on one day the shift is only from 8:00 to 18:00, it will always
    work on 24 hours days. This is why a preprocessing step is added, to prepare the
    data for the algorithm
  
  2. There has to be an improvement on every cycle. If there is no improvement, we have
    reached a **local** minimum, and the algorithm stops 

### Preprocessing

  In order to illustrate the algorithm, we will add an example. For this example, we will
  consider 2 employees, working on 2-day weeks of 2, and 6 hours each day. Take in mind that this
  is for demostration purposes, and the results here can be expanded to 7 days, 24 hours and any
  number of employees.

  Imagine you have the following availabilities, where *O* means available and *X* means not available:

  Day 1
  | Hour | Jose Perez | Carlos Diaz |
  | --- | --- | --- |
  | 08:00 | O  | O  |
  | 09:00 | O  | O  |
  | 10:00 | O  | X  |
  | 11:00 | X  | O  |
  | 12:00 | O  | O  |
  | 13:00 | X  | O  |

  Day 2
  | Hour | Jose Perez | Carlos Diaz |
  | --- | --- | --- |
  | 09:00 | O  | O  |
  | 10:00 | O  | X  |
  | 11:00 | O  | O  |
  | 12:00 | O  | O  |
  
  To prepare the data for the algorithm, we need to preprocess it. The preprocessing steps
  are the following:

  1. Add the missings hours to each day.

  For example, on day 2, which is a 2 days shift, we add 1 hour before and 1 hour after, where
  no one is available

  Day 1
  | Hour | Jose Perez | Carlos Diaz |
  | --- | --- | --- |
  | 08:00 | O  | O  |
  | 09:00 | O  | O  |
  | 10:00 | O  | X  |
  | 11:00 | X  | O  |
  | 12:00 | O  | O  |
  | 13:00 | X  | O  |

  Day 2
  | Hour | Jose Perez | Carlos Diaz |
  | --- | --- | --- |
  | 08:00 | X  | X  |
  | 09:00 | O  | O  |
  | 10:00 | O  | X  |
  | 11:00 | O  | O  |
  | 12:00 | O  | O  |
  | 13:00 | X  | X  |

  2. We calculate what is called **availability groups**: An availability group will be a group of 
    continuous hours in the same day during wich an employee can work. For this example, our groups
    will be

    - Group 1-1-1: Jose Perez starting at 8 can work 3 hours
    - Group 1-1-2: Jose Perez starting at 12 can work 1 hour
    - Group 1-2-1: Carlos Diaz starting at 8 can work 2 hours
    - Group 1-2-2: Carlos Diaz starting at 11 can work 3 hours
    - Group 2-1-1: Jose Perez starting at 9 can work 4 hours
    - Group 2-2-1: Carlos Diaz starting at 9 can work 1 hour
    - Group 2-2-2: Carlos Diaz starting at 11 can work 2 hours

### Base Solution

  The base solution is really simple and directly addresses the problem of minimizing shift swaps. We 
  iterate over each hour of each day, and select the longest availability group that covers that hour.
  
  Continuing with the example:
  
  We need on day 1, the longest shift that can cover 8:00. This is Group 1-1-1. So, Jose Perez is selected
  as the first employee.

  | Day | Hour | Employee |
  | --- | --- | --- |
  | 1 | 08:00 | Jose Perez  |
  | 1 | 09:00 | Jose Perez  |
  | 1 | 10:00 | Jose Perez  |
  | 1 | 11:00 | X  |
  | 1 | 12:00 | X  |
  | 1 | 13:00 | X  |
  | 2 | 08:00 | X  |
  | 2 | 09:00 | X  |
  | 2 | 10:00 | X  |
  | 2 | 11:00 | X  |
  | 2 | 12:00 | X  |
  | 2 | 13:00 | X  |

  Then we move to the next empty hour, which is day 1, at 11, and look for the largest group that covers that hour.
  This is group 1-2-2. So Carlos Diaz is selected.

  | Day | Hour | Employee |
  | --- | --- | --- |
  | 1 | 08:00 | Jose Perez  |
  | 1 | 09:00 | Jose Perez  |
  | 1 | 10:00 | Jose Perez  |
  | 1 | 11:00 | Carlos Diaz  |
  | 1 | 12:00 | Carlos Diaz  |
  | 1 | 13:00 | Carlos Diaz  |
  | 2 | 08:00 | X  |
  | 2 | 09:00 | X  |
  | 2 | 10:00 | X  |
  | 2 | 11:00 | X  |
  | 2 | 12:00 | X  |
  | 2 | 13:00 | X  |

  We continue to fill the table until we are done

  | Day | Hour | Employee |
  | --- | --- | --- |
  | 1 | 08:00 | Jose Perez  |
  | 1 | 09:00 | Jose Perez  |
  | 1 | 10:00 | Jose Perez  |
  | 1 | 11:00 | Carlos Diaz  |
  | 1 | 12:00 | Carlos Diaz  |
  | 1 | 13:00 | Carlos Diaz  |
  | 2 | 08:00 | X  |
  | 2 | 09:00 | Jose Perez  |
  | 2 | 10:00 | Jose Perez  |
  | 2 | 11:00 | Jose Perez  |
  | 2 | 12:00 | Jose Perez  |
  | 2 | 13:00 | X  |

  On this step, we have a valid solution; it is not the optimal, but it performs few shift swaps and covers every hour of every day
  when possible. This step, does not verify the hour count of every employee, however. So in this case, we can see that Jose Perez
  works more than Carlos Diaz

  | Employee | Hours Worked |
  | --- | --- |
  | Jose Perez | 7 |
  | Carlos Diaz | 3 | 

### Cost
  Before each iteration, and once we have a valid solution, we need to calcualte a cost for the current solution. The cost is very
  simple:

  We take the difference in hours between the employee that works the most and the one that works the least. And we add that with the
  number of times and employee is swapped each day. For the example, the cost of the function will be:

  $$ c = (7 - 3) + 1 $$

  $$ c = 5 $$

  Now that we have a numeric value, we can iterate to reduce it as much as we can.

### Iterations
  The iteration process has the following steps:

  1. We need to select the employee that works the most (Jose Perez)
  2. We need to select the employee that works the least (Carlos Diaz)
  3. We calculate how many hours the first works over the second. We will call this: $D$ (4 hours)
  
  4. Here we start a loop: We need to find 2 availability groups, one for each employee. The conditions that need to be met are:
    
  - The first employee has to work during this availability group
  - The second employee must be able to work during this time window
  - The size of the window must be at least 2, and at most $ D - 1 $. 2 because if it's only 1 hour, then we will reduce two hours in
    difference, but will increase 2 shift swaps (except on start and end of day). So the ending cost will be the same. We need the 
    time window to be at most $ D - 1 $ (3 in this case), because if it's D, and the employees swap, now the employee with least hours will
    become the one with most hours, and the one with most hours will become the one with least hours.

  If attempting to find an availability group of $ D -1 $ doesn't work, then we go down 1, and a find a group of $D - 2$, and so in until we reach
  groups of 1. When we reach this point, we give up, and we conclude that the employee that works the most can't swap with the one that works the least,
  so we move the lower limit up, and we attempt to swap between the employee that works the most, and the employee that works the second least, and we
  repeat the process.

  In the example, we will find one pair of availability groups:

    - Group 2-1-1: Jose Perez starting at 9 can work 4 hours
    - Group 2-2-2: Carlos Diaz starting at 11 can work 2 hours

  Here we can see that they match in 2 hours, and that Josse Perez works during those 2 hours, so we swap them

  The result is the following: 

  | Day | Hour | Employee |
  | --- | --- | --- |
  | 1 | 08:00 | Jose Perez  |
  | 1 | 09:00 | Jose Perez  |
  | 1 | 10:00 | Jose Perez  |
  | 1 | 11:00 | Carlos Diaz  |
  | 1 | 12:00 | Carlos Diaz  |
  | 1 | 13:00 | Carlos Diaz  |
  | 2 | 08:00 | X  |
  | 2 | 09:00 | Jose Perez  |
  | 2 | 10:00 | Jose Perez  |
  | 2 | 11:00 | Carlos Diaz  |
  | 2 | 12:00 | Carlos Diaz  |
  | 2 | 13:00 | X  |

  Once we have performed a shift swap, we recalculate the cost based on the worked hours and the times the employees swap shifts:

  | Employee | Hours Worked |
  | --- | --- |
  | Jose Perez | 5 |
  | Carlos Diaz | 5 | 

  $$ c = (5 - 5) + 2 $$

  $$ c = 2 $$

### Ending the Loop

  Since the cost is lower, we continue to iterate, until we either find no solution, or find a solution that has a higher cost
  that the previous one. When this happens, we restore the previous solution and end the loop.

  In the example, the hour difference between the two employees is 0, which means that we would have to find a set of availability
  groups of size $0 - 1 = -1$, which is impossible, so the algorithm would end.

