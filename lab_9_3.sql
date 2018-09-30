/*Лаба 9.3 Определить ранги сотрудников по получаемой ими зарплате в отделах.

*/


select department_id, last_name, 
 salary,
dense_rank() over (partition by department_id
 order by salary desc)
as sal_rank
from employees
;
