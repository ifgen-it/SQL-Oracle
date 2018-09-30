/*Лаба 9.8 Определить список отделов, суммарная зарплата в которых больше
средней суммарной зарплаты в отделах в городах, где расположены отделы.
В отделах без сотрудников суммарную зарплату считать равной нулю и учитывать
при подсчёте среднего значения по городу.

*/

with
t1 as (
select department_id, sum(salary) sum_sal, location_id
from employees
left join departments
using (department_id )
where department_id is not null
group by department_id, location_id
order by 1
)

, t2 as (
select distinct location_id, department_id,  nvl(
sum(salary) over (partition by location_id, department_id ) , 0 ) dep_sum_sal
from departments
left join employees
using (department_id)
order by 1,2
)

, t3 as (
select distinct location_id, 
avg(dep_sum_sal) over(partition by location_id ) loc_avg_sal
from t2
order by 1 )

select department_id
from t1
left join t3
using (location_id )
where sum_sal > loc_avg_sal
order by 1
;
