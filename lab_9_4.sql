/*Лаба 9.4 Определить накапливаемую в пределах отделов сумму зарплат сотрудников.

*/

select department_id, last_name, salary,
sum(salary) over (partition by department_id order by salary, last_name) accum_sal
from employees
;
