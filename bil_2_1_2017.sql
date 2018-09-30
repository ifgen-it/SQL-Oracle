/*Билет 2.1_2017 Создать запрос для получения списка городов и отделов, расположенных в них. Результаты представить в виде:

Город           Отдел
Seattle         Accounting (20), Administration(3),Benefits(5), Construction(8),Control And Credit(4)
                5 отделов,40 сотрудников
Toronto         Marketing(7)
                1 отдел, 7 сотрудников

Список отделов  в  каждом городе должен быть отсортирован по алфавиту.  У каждого отдела в скобках длжно быть указано количество, работающих в нем сотрудников. После каждого города должен быть предусмотрен вывод информации о количестве отделов в городе и общем количестве сотрудников в городе.  В последней строке должно отображаться общее количество отделов и сотрудников в организации. 
Задачу решить без использования функции listagg. 

*/
with
locs as (
select location_id, city
from locations )

, deps as (
select department_id, count(employee_id) cnt
from employees
group by department_id
order by 1
)

, t1 as (
select city, department_name dept, cnt, 
department_name || ' (' || cnt || ')' dept_cnt
from deps
natural join departments
natural join locs
order by 1, 2 )

,t2 as (
select city, dept_cnt,
row_number() over(partition by city order by dept_cnt ) r
from t1 )

, t3 as (
select city, regexp_replace( sys_connect_by_path(dept_cnt, ', '), '^,\s', '' ) dept_cnt_list
from t2
where connect_by_isleaf =1
start with r = 1
connect by prior r + 1 = r
and prior city = city
)

, t4 as (
select distinct city,
count(dept) over(partition by city) cnt_dept,
 sum(cnt) over(partition by city ) sum_emp
from t1
order by 1 )

,t5 as (
select city, cnt_dept,
case 
when cnt_dept = 1 then 'отдел'
when cnt_dept in (2,3,4) then 'отдела'
else 'отделов' end dep_s,
sum_emp,
case 
when sum_emp in (1,21,31,41,51,61,71,81,91) then 'сотрудник'
when sum_emp in (2,3,4, 22,23,24,32,33,34,42,43,44,52,53,54,62,63,64,72,73,74,82,83,84,92,93,94) then 'сотрудника'
else 'сотрудников' end emp_s
from t4 )

,t6 as (
select city,
to_char(cnt_dept) ||' '|| dep_s ||', '||
to_char(sum_emp) ||' ' ||emp_s dep_emp_str
from t5 )

,t7 as (
select city, dept_cnt_list department , 1 ord
from t3
union 
select city, dep_emp_str, 2
from t6
order by 1,3 )

select case
when ord = 1 then city
else ' ' end city, department
from t7

;
