# Guardianes Informáticos

## Mathematical approach

### Problem
  The problem we will atempt to solve is the following:
  We need to assign employees to a 7-day week based on their availability. An employee is either
  avaiable, or is not, at a given hour, on  given day. 

  | Hour | Jose Perez | Carlos Diaz |
  | --- | --- | --- |
  | 08:00 | O  | O  |
  | 09:00 | O  | O  |
  | 10:00 | O  | X  |
  | 11:00 | X  | O  |
  | 12:00 | O  | O  |
  | 13:00 | X  | O  |

  In the table above, we can se that **Jose Perez** is available at 8, 9 10 and 12, 
  while **Carlos Diaz** is available at 8, 9, 11, 12 and 13.

  There are exactly 8 configuration we can make while also filling every hour of the schedule.
  The catch is, however, that we need to find one configuration that minimizes the difference of
  hours each employee works, while also, swapping their shifts the mimum possible.

  In this case, the optimal configuration is this one:

  | Hour | User |
  | --- | --- |
  | 08:00 | Jose Perez  |
  | 09:00 | Jose Perez  |
  | 10:00 | Jose Perez  |
  | 11:00 | Carlos Diaz  |
  | 12:00 | Carlos Diaz  |
  | 13:00 | Carlos Diaz  |

  As you can see, every employee works exactly 3 hours, and they only swap shifts once.

  We can see this as an optimization problem if we define a cost for each configuration and then try to minimize
  cost. The method used to find the solutions will depend on how the problem was described. The description here
  does not allow for linear programming to be used, but any other number of non-linear methods can be applied.

## Solution


#### Index definitions

  The day of the week $i \in \lbrace 0..6 \rbrace $

  The hour of the day $j \in \lbrace 0..23 \rbrace $

  The index of the employee that can be assigned to work on a given hour on a given day $k \in \lbrace 0..N \rbrace $ 


#### Parameter Definition

  The cost of swapping from one employee to another on the same day: $C_s$

  The cost of having a 1-hour difference between the employee that works the most and the one that works the least: $C_w$

  If the employee $k$ is available for work on the hour ${j} of the day 
  ${i} (this is an integer variable, either 0 or 1): $e_{ijk}$

#### Variable Definitions

  If the employee $k$ is actually assigned to work on the hour $j$ of the day $i$: $x_{ijk}$

#### 

  Once our parameters and variables are set, we need to define a function, that will use all these values and return
  a number that represents the cost of a specific schedule configuration. For this problem, the cost of a 
  schedule will be determined by two factors:
  - The hour difference between the employee that works the most and the one that works the least
  - The the number of times an employee swaps shifts with another one in the same day.

  So we need to express these two statements using numeric values. For the first one we have:

  $$f(x) = max(\sum_{i} {e_{ijk}x_{ijk}}) - min(\sum_{i} {e_{ijk}x_{ijk}}) $$

  For the second part of the cost, we need to calculate how many times an employee is
  swapped on the same day. We can express

  $$\sum_{k = 1 \to N}{s_k}$$

  Where

  $$
    s_k = \begin{dcases}
    1   & \text{ if } {e_{ijk - 1}x_{ijk - 1}} != 0 \\
    0   & \text{ if } {e_{ijk - 1}x_{ijk - 1}} == 0
    \end{dcases}
  $$ 
