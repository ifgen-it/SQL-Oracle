/*Билет 6.4_2018 Определить список сотрудников (таблица Employees),
у которых в именах и фамилиях содержится, по крайней мере, по три совпадающие буквы. 

Результат представить в виде:

Сотрудник           Результат
Alberto Errazuriz   Совпадают три буквы (a,e,r)
Alexaner Hunold     Совпадают три буквы (d,l,n)
Elizabeth Bates     Совпадают четыре буквы (a,b,e,t)

*/

with
t1 as(
select employee_id id, lower(first_name) fn, lower(last_name) ln
from employees
)

, first(id, fn, l, c) as (
select id, fn, 1 l, regexp_substr(fn,'\w',1,1) c
from t1
union all
select id, fn, l+1, regexp_substr(fn,'\w',1,l+1)
from first
where l < regexp_count(fn,'\w')
)

, first1 as (
select distinct id, c
from first
order by id, c )

, last(id, ln, l, c) as (
select id, ln, 1 l, regexp_substr(ln,'\w',1,1) c
from t1
union all
select id, ln, l+1, regexp_substr(ln,'\w',1,l+1)
from last
where l < regexp_count(ln,'\w')
)

, last1 as(
select distinct id, c
from last
order by id, c )

,t2 as (
select f.id, f.c
from first1 f
cross join last1 l
where f.id = l.id and f.c = l.c )

, t3 as (
select id, c, count(c) over(partition by id) max_c
from t2 )

, t4 as (
select id, c, max_c
from t3
where max_c >= 3 )

,t5 as (
select distinct id, max_c, listagg(c, ',') within group (order by c) over(partition by id) c_list
from t4
order by 1 )

select e.first_name || ' ' || e.last_name as "Сотрудник"
, case
when max_c = 3 then 'Совпадают три буквы (' || c_list || ')'
when max_c = 4 then 'Совпадают четыре буквы (' || c_list || ')'
else 'Совпадает более четырех букв (' || c_list || ')'
end as "Результат"
from t5
left join employees e
on (t5.id = e.employee_id)
order by 1
;
