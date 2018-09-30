/*Лаба 9.5 Вывести список сотрудников каждого отдела в строку через запятую 

*/

select distinct department_id, 
listagg(last_name, ', ') within group (order by last_name) over (partition by department_id ) name_list
from employees
order by department_id
;
