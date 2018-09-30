/*Билет 1.5_2018 Имеется таблица с двумя столбцами – дочерняя вершина и
родительская вершина. Определить наборы вершин, образующих связанные множества.

Например, для таблицы:

Дочерняя вершина	Родительская вершина
1	                2
2	                4
4	                5
4	                3
7	                6

результат должен быть

Связанные множества
1,2,3,4,5
6,7

*/

with 
input as
(
select 1 id, 2 pid from dual
union all
select 2, 4 from dual
union all
select 4, 5 from dual
union all
select 4, 3   from dual
union all
select 7, 6 from dual
union all
select 5, 8 from dual
union all
select 9, 5 from dual
)
,

all_parents as 
(
select pid roots
from input
minus
select id 
from input
)
,
new_input as
(
select roots r, null p
from all_parents
)
,
good_input as
(
select id, pid
from input
union
select r, p
from new_input
)

, t1 as (
select id, pid, level l,
connect_by_root(id) root, connect_by_isleaf leaf, sys_connect_by_path(id, ' ') path 
from good_input
connect by prior id = pid
order by l
)

, t2 as (
select *
from t1
where leaf = 1 and
root in (
select id from good_input
where pid is null )
)

, t3 as (
select id , root, listagg(path) within group (order by path) over(partition by id) path1
from t2 )

,t4 as (
select id, root, 
listagg(path1) within group (order by path1) over(partition by root) path2
from t3 )

,t5 as (
select id, root, path2,
regexp_count(path2, '\d+') cnt
from t4 )

,t6 as (
select id, root, path2, cnt, max(cnt) over(partition by id) mcnt
from t5
order by 1 )

, t7 as (
select distinct root r, path2 p
from t6
where cnt >= mcnt )

,t8 as (
select distinct r, regexp_substr(p, '\d+',1, level) substr
from t7
connect by level <= regexp_count(p, '\d+')
order by 1,2 )

select distinct listagg(substr, ',') within group (order by substr) over(partition by r) "Связанные множества"
from t8
order by 1
;
