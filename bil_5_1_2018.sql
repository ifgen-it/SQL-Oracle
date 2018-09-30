/*Билет 5.1_2018 Для каждого отдела вывести фамилии и зарплаты трех сотрудников, получающих самые высокие зарплаты в отделе.
Если самую  низкую зарплату  у найденных трех сотрудников отдела получают и какие-то другие сотрудники этого отдела,
они тоже должны попасть в список. 
*/

with
t1 as (
select department_id, last_name, salary,
row_number() over(partition by department_id order by salary desc ) r
from employees
order  by department_id, salary desc )

select a.department_id, a.last_name, a.salary, a.r
from t1 a
join t1 b
on ( b.department_id = a.department_id 
     and b.r = 3 )
where a.salary >= b.salary
order by 1,  4
;
