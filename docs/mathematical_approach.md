# Guardianes Informáticos

## Mathematical approach

### Problem
  The problem we will atempt to solve is the following:
  We need to assign users to a 7-day week based on their availability. A user is either
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
