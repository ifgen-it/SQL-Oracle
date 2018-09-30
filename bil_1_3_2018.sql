/*Билет 1.3_2018 Вывести список сотрудников, зарплату и нарастающую сумму зарплат в пределах отдела
(сумма должна нарастать вместе с величиной зарплаты - от самой маленькой к самой большой).
Задачу решить без использования аналитических функций.

*/

with
table_1 as
(
select department_id, employee_id, salary
from employees
order by 1,3
)
,
table_2 as (
select department_id,  employee_id, salary, rownum row_num
from table_1
)
, table_3 as (
select t1.department_id,
t1.employee_id, t1.salary,
sum(t2.salary) accr_sal
from table_2 t1
join table_2 t2
on (
t1.department_id = t2.department_id )
and
t1.row_num >= t2.row_num
group by 
t1.department_id, t1.employee_id,
t1.salary
order by 
t1.department_id, t1.salary
)

select *
from table_3
;
