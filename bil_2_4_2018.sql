/*Билет 2.4_2018 Проверить наличие циклов в таблице подчиненностей.
Вывести циклические зависимости в строчку в виде Номер1.Имя1->Номер2.Имя2->…Номер1.Имя1,
начиная с первого по алфавиту имени.
Например, для таблицы подчинённостей:

Номер   Имя       Номер_начальника
1       Алексей   2
2       Пётр      3
3       Павел     4
4       Иван      2
5       Кристина  3
6       Андрей    5

Результат должен быть:

CYCLE
4.Иван->3.Павел->2.Пётр->4.Иван

*/

with 
t1 as (
select 1 employee, 'Алексей' name, 2 manager from dual union all
select 2, 'Пётр' , 3 from dual union all
select 3, 'Павел' , 4 from dual union all
select 4, 'Иван' , 2 from dual union all
select 5, 'Кристина' , 3 from dual union all
select 5, 'Кристина' , 8 from dual union all
select 6, 'Андрей' , 5 from dual union all
select 7, 'Евген' , 6 from dual union all
select 8, 'Сергей' , 7 from dual

)

, t2 as (
select employee emp, name, manager mgr, level lev,
connect_by_isleaf leaf, connect_by_iscycle cycle, connect_by_root(employee) root
from t1
connect by nocycle prior employee = manager

order by level, emp )

, t3 as (
select *
from t2
where cycle = 1 )

, t4 as (
select emp, name, mgr, lev, cycle, root,
min(lev) over (partition by emp) min_lev
from t3
)

, t5 as (
select distinct emp, name, mgr
from t4
where lev = min_lev
order by 1 )

, t6 as (
select emp, mgr, level l,
sys_connect_by_path(emp, ' ') path

from t5
where connect_by_isleaf = 1
connect by nocycle prior emp  = mgr
order by 1 )

, t7 as (
select distinct emp,
regexp_substr(path, '\d+', 1, level) emp_cyc
from t6
connect by level <= regexp_count(path, '\d')
order by 1 )

, t8 as (
select distinct listagg(emp_cyc) within group (order by emp_cyc) over (partition by emp ) cycle_list, emp
from t7
order by 1 )

, t9 as (
select cycle_list cl, emp, name, mgr
from t8
natural join t5 )

, t10 as (
select distinct cl, emp, name, min(name) over(partition by cl) min_n
from t9 order by 1)

, t11 as (
select cl, emp, name
from t10 where name = min_n )

, t12 as (
select cl, emp, name, mgr, level l
from t9
start with (cl, emp) in (
select cl, emp from t11
)
connect by nocycle prior emp = mgr
order by cl, l )

,t13 as (
select cl, to_char(emp) || '.' || name str, l
from t12
union all
select cl, to_char(emp) || '.' || name  , null
from t11
order by 1, l  )

select distinct listagg(str, '->') within group (order by l nulls last) over (partition by cl) cycle
from t13
order by 1
;
