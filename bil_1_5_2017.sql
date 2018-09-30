/*Билет 1.5_2017 Есть таблица с парами значений, связанными отношением.
Одно значение может быть связано с несколькими, те в свою очередь могут быть связаны друг с другом.
В результате, значения транзитивно образуют связанные множества. На входе имеем некое значение,
нужно получить все элементы множества, к которому оно относится. Результат вывести в виде строки с
запятой в качестве разделителя.

Например, для таблицы:

A	B
3	2
4	3
6	4
7	8
9	10

Результат  для заданного значения 4 должен быть:
2,3,4,6


*/

with 
input as
(
select 3 id, 2 pid from dual
union all
select 4, 3 from dual
union all
select 6, 4 from dual
union all
select 7, 8 from dual
union all
select 9, 10 from dual
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
select distinct r, to_number(
regexp_substr(p, '\d+',1, level)) substr
from t7
connect by level <= regexp_count(p, '\d+')
order by 1,2 )

,t9 as (
select distinct listagg(substr, ', ') within group (order by substr) over(partition by r) ls
from t8
order by 1 )

select ls linked_set
from t9
where ls like '%&search_number%'
;
