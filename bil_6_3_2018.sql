/*Билет 6.3_2018 Для каждого отдела из таблицы Departments отобразить в виде одной строки
с запятой в качестве разделителя фамилии сотрудников, работающих в нем.
Фамилии сотрудников должны быть отсортированы по алфавиту.
Задачу  решить без использования функций Listagg и wm_concat.

*/

with
t1 as(
select department_id d, last_name l
from employees
order by 1,2 )

,t2 as (
select d, l, rownum r1
from t1 )

,t3 as (
select d, l, r1 - min(r1) over(partition by d) +1 r2
from t2 )

,t4 as(
select d, regexp_replace(sys_connect_by_path(l, ', '), '^,\s', '') path
from t3
where connect_by_isleaf = 1
start with r2 = 1
connect by prior r2 + 1 = r2 and prior d = d
order by d )

select d.department_id, d.department_name, nvl(t4.path, ' ') employee_list
from departments d
left join t4 on (d.department_id = t4.d)
order by 1
;
