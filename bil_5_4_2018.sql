/*Билет 5.4_2018 Предполагая, что не существует зарплаты сотрудников (таблица Employees), большей 100000,
для каждого сотрудника, имеющего более двух подчиненных, вывести представление зарплаты в десятичной и
двоичной системах счисления (без ведущих нулей).

*/

with
tt1 as (
select manager_id, employee_id, salary,
count(*) over (partition by manager_id ) count
from employees
order by manager_id )

, tt2 as (
select distinct manager_id
from tt1
where count >= 2 )

, t1 as (
select employee_id r, 
salary dec
from employees
where employee_id in (
select * from tt2 ) )

, t2 as (
select r, dec d1, trunc(dec/2) d2, 
mod (dec, 2 ) ost
from t1 )

, recur(r, d1, d2, ost) as (
select r, d1, d2, ost
from t2
union all
select r, d2, trunc(d2/2), mod(d2, 2)
from recur
where d2 > 0
)

, t3 as (
select 
distinct r,
listagg(ost) within group (order by d1 ) over(partition by r) bin
from recur )


select r empl
, dec dec_sal
, bin bin_sal
from t1
join t3
using (r)
order by 1
;
